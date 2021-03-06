
#' R6 Class for Kafka Consumer
#'
#' @import data.table
#' @import jsonlite
#' @import rJava
#'
#' @export
#'
kafka_consumer_class <-
  R6::R6Class(

    #### options ###############################################################
    classname = "kafka_class_consumer",

    portable = TRUE,

    parent_env = asNamespace("kafkaesque"),




    #### public ################################################################

    public =
      list(

        ## data ################################################################

        #' @field java_consumer reference to the underlying Java object
        java_consumer = list(),



        ## methods #############################################################

        #' Initialize
        #'
        #' @description
        #' Create a new consumer object.
        #' Instead of \code{kafka_class_consumer$new()} one can use \code{kafka_consumer()}
        #'
        #' @return \code{self} for method chaining
        #'
        initialize =
          function() {
            self$java_consumer <- rJava::.jnew("kafkaesque/Kafka_consumer")
            self$records       <- kafka_records_class$new(self)
          },


        #'
        #' @description
        #' Code run when object is removed from session
        #'
        finalize =
          function() {
            self$java_consumer$end()
          },


        #'
        #' @description
        #' Spin up consumer and connect it to Kafka cluster
        #'
        #' @return \code{self} for method chaining
        #'
        start =
          function() {
            self$java_consumer$start()

            # return for method chaining
            invisible(self)
          },


        #'
        #' @description
        #' Disconnect consumer from Kafka cluster
        #'
        #' @return \code{self} for method chaining
        #'
        end =
          function() {
            self$java_consumer$end()

            # return for method chaining
            invisible(self)
          },

        #'
        #' @description
        #' Whether or not consumer is active (has been started or not)
        #'
        #' @return TRUE/FALSE
        #'
        running =
          function() {
            self$java_consumer$running
          },




        #'
        #' @param timeout_ms number of miliseconds to wait for polling to return
        #'  messages, defaults to Inf
        #'
        #' @description
        #' Polling for messages
        #'
        #' @return the number of records retrieved by last poll
        #'
        poll =
          function(timeout_ms = Inf) {
            stopifnot( self$running() == TRUE )

            if (  is.infinite(timeout_ms) ){
              self$java_consumer$poll()
            } else {
              .jcall(
                obj       = self$java_consumer,
                returnSig = "I",
                method    = "poll",
                as.integer(timeout_ms)
              )
            }

            # return for method chaining
            self$java_consumer$records$count()
        },


        #'
        #' @param sync synchronous or asynchronous commit
        #'
        #' @description
        #'
        #' Commit offsets returned on the last poll() for all the subscribed
        #' list of topics and partitions.
        #'
        #' @return \code{self} for method chaining
        #'
        commit =
          function(sync = TRUE) {

            # execute commit
            if ( sync == TRUE ){
              self$java_consumer$commit_sync()
            } else {
              self$java_consumer$commit_async()
            }

            # return for method chaining
            invisible(self)
          },




        #'
        #' @field records
        #'
        #' If poll() did fetch any messages, they are stored here until the
        #' next call to poll().
        #'
        #' Note: Consider using consume methods instead of managing records on your own.
        #'
        records = list(),



        #' @description
        #'
        #' Consume one message either from the records already fetched from last poll or via initiating a new poll.
        #'
        consume_next =
          function (
          ) {
            stopifnot( self$running() == TRUE )
            self$records$next_record()
          },


        #' @param expr expression (e.g. via \code{expression(...)}) that will
        #'   process a single message
        #'
        #' @param check expression (e.g. via \code{expression(...)}) that will
        #'   evaluate to TRUE or FALSE to either further process messages or
        #'   stop processing and ask function to return
        #'
        #' @param batch defaults to FALSE, Kafka's the default is to poll for as much
        #'   data as one can get given the consumers limits on the number and
        #'   size of messages as well as the chosen timeout. No matter how many
        #'   data is returned from a poll the method process - if batch is set to
        #'   FALSE - return only a single message at a time. If batch is set to
        #'   TRUE however the msgs data.frame/data.table will contain all messages
        #'   that were retrieved by the last poll unless consumed already.
        #'
        #' @description
        #'
        #' Method that is basically an infinite loop (until the check expression
        #' evaluates to FALSE) that will evaluate the supplied expressionfor
        #' each loop.
        #'
        #' There are several objects available to the expression supplied:
        #'
        #' - msgs: a data.frame/data.table with one or more rows - see batch parameter
        #' - counter: single number equal to the number of messages already processed.
        #' - start_time: the result of a call to Sys.time() when first the method started
        #'
        #'
        consume_loop =
          function (
            expr  = expression(print(msgs)),
            check = expression(counter < 1),
            batch = FALSE
          ) {

            start_time <- Sys.time()
            counter    <- 0

            # loop while check evaluates to TRUE
            if ( batch == TRUE ){

              while ( eval(check) ){
                msgs    <- self$records$next_record_batch()
                eval(expr)
                counter <- counter + nrow(msgs)
              }

            } else {

              while ( eval(check) ){
                msgs    <- self$records$next_record()
                eval(expr)
                counter <- counter + 1
              }

            }

            # return
            list(
              start_time = start_time,
              end_time   = Sys.time(),
              n          = counter
            )
          },


        #'
        #' @param ... a series of properties provided as \code{key = "values"}
        #' @param .properties a list of properties provided as  \code{.properties = list(key = "values", ...)}
        #'
        #' @description
        #' Retrieving current current set of properties.
        #' If properties are supplied via props parameter thos properties will
        #' be set.
        #'
        #' @return returns a list of properties
        #'
        #'
        props =
          function(..., .properties = NULL) {

            # ? set properties
            if ( !is.null(.properties) ){
              self$java_consumer$props_set(
                .jcastToArray(names(.properties)),
                .jcastToArray(format(.properties, scientific = FALSE))
              )
            } else if ( length(list(...)) > 0 ){
              .properties <- list(...)
              self$java_consumer$props_set(
                .jcastToArray(names(.properties)),
                .jcastToArray(format(.properties, scientific = FALSE))
              )
            }

            # return properties
            jsonlite::fromJSON(
              iconv(
                x  = self$java_consumer$props$to_json(),
                to = "UTF-8"
              )
            )
          },


        #'
        #' @description
        #' Subscribe to one or more topics
        #'
        #' @param topics character vector defining topics or topic regex to subscribe to
        #'
        #' @return \code{self} for method chaining
        #'
        topics_subscribe =
          function(topics) {

            stopifnot( self$running() == TRUE )

            topics_string_array <- .jarray(topics)
            self$java_consumer$topics_subscribe(topics_string_array)

            # return for method chaining
            invisible(self)
          },


        #'
        #' @description
        #'
        #' List current subscription
        #'
        topics_subscription =
          function() {

            stopifnot( self$running() == TRUE )

            self$java_consumer$topics_subscription()
          },

        #'
        #' @param full defaults to FALSE, whether or not to return all data
        #'   returned fro Java object (TRUE) or only a simple character vector
        #'   listing the names of the data topics available for consumption
        #'   (FALSE)
        #'
        #' @description
        #'
        #' List topics available to consumer
        #'
        topics_list =
          function(full=FALSE) {

            stopifnot( self$running() == TRUE )

            tmp <- jsonlite::fromJSON(self$java_consumer$topics_list())
            if ( full == FALSE ) {
              topics <- unique(unlist(lapply(tmp, `[[`, "topic")))
              return(topics[!grepl("^__", topics)])
            } else {
              return ( tmp)
            }
          },


        #' @description
        #'
        #' Seek to beginning of all topics subscribed and all partitions
        #'
        topics_seek_to_beginning =
          function(){
            # execute seeking
            self$java_consumer$topics_seek_to_beginning()
          },


        #' @description
        #'
        #' Seek to end of all topics subscribed and all partitions
        #'
        topics_seek_to_end =
          function(){
            # execute seeking
            self$java_consumer$topics_seek_to_end()
          },


        #'
        #' @description
        #'
        #'
        #'
        topics_offsets =
          function() {
            obj <- self$java_consumer$topics_offsets()

            # return
            data.table::data.table(
              topic     = obj$topics,
              partition = obj$partitions,
              offset    = obj$offsets
            )
          }

      ),

    #### private ###############################################################

    private = NULL
  )
