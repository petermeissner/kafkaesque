
#' R6 Class for Kafka Consumer
#'
#' @import data.table
#' @import jsonlite
#' @import rJava
#'
#' @export
#'
kafka_class_consumer <-
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

        #'
        #' @description
        #' Create a new consumer object.
        #' Instead of \code{kafka_class_consumer$new()} one can use \code{kafka_consumer()}
        #'
        #' @return returns object reference for method chaining
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
        #' @return returns object reference for method chaining
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
        #' @return returns object reference for method chaining
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
        #' @description
        #' Polling for messages
        #'
        #' @return returns object reference for method chaining
        #'
        poll =
          function(timeout_ms = NULL) {

            if (  is.null(timeout_ms) ){
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
            invisible(self)
        },


        #'
        #' @description
        #'
        #' If poll() did fetch any messages, they are stored here until the
        #' next call to poll().
        #'
        #' Note: Consider using consume methods instead of managing records on your own.
        #'
        records = list(),


        #' @description
        #'
        #' Set/return offsets.
        #'
        #' @param offset defaults to NULL, if set to NULL now new offset will
        #'   be set, if set to a number this number will be used as new offset
        #'
        offset =
          function (
            offset = NULL
          ) {
            #### TODO
            message("TBD")
          },


        #' @description
        #'
        #' Consume one message either from the records already fetched from last poll or via initiating a new poll.
        #'
        consume_next =
          function (
          ) {
            self$records$next_record()
          },


        #' @param expr expression (e.g. via \code{expression(...)}) that will
        #'   process a single message
        #' @param check expression (e.g. via \code{expression(...)}) that will
        #'   evaluate to TRUE or FALSE to either further process messages or
        #'   stop processing and ask function to return
        #'
        #' @description
        #' If poll() did fetch any messages, they are stored here until the next
        #' call to poll()
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
                msgs    <- self$records$next_message()
                eval(expr)
                counter <- counter + nrow(msgs)
              }

            } else {

              while ( eval(check) ){
                msgs    <- self$records$next_message_batch()
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
        #' @description
        #' Polling for messages
        #'
        props =
          function() {
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
        #' @return returns object reference for method chaining
        #'
        topics_subscribe =
          function(topics) {
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
            self$java_consumer$topics_subscription()
          },

        #'
        #' @description
        #'
        #' List topics available to consumer
        #'
        topics_list =
          function(full=FALSE) {
            tmp <- jsonlite::fromJSON(self$java_consumer$topics_list())
            if ( full == FALSE ) {
              topics <- unique(unlist(lapply(tmp, `[[`, "topic")))
              return(topics[!grepl("^__", topics)])
            } else {
              return ( tmp)
            }
          }
      ),

    #### private ###############################################################

    private = NULL
  )
