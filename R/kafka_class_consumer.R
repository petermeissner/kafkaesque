
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
        #' Create a new consumer object
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
        start =
          function() {
            self$java_consumer$start()
          },


        #'
        #' @description
        #' Disconnect consumer from Kafka cluster
        #'
        end =
          function() {
            self$java_consumer$end()
          },


        #'
        #' @description
        #' Polling for messages
        #'
        #' @return returns the number of new messages fetched
        #'
        poll =
          function() {
            self$java_consumer$poll()
        },


        #'
        #' @description
        #'
        #' If poll() did fetch any messages, they are stored here until the next call to poll()
        #'
        records = list(),

        #' @description
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
        consume_next =
          function (
          ) {
            records$next_record()
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
        consume_loop_one_by_one =
          function (
            expr = expression(print(msg)),
            check = expression(TRUE)
          ) {

            start_time <- Sys.time()
            counter    <- 0


            # loop while check evaluates to TRUE
            while ( eval(check) ){

              # poll for new messages
              n <- self$poll()

              # check if new messages were received
              if ( n > 0 ){

                # retrieve bulk of messages and loop over them one by one
                records <- self$records()
                for ( i in seq_len(nrow(records)) ){

                  # extract single message and process it
                  msg <- records[i, ]
                  eval(expr)
                }

                # update counter
                counter <- counter + n
              }
            }

            # return
            list(
              start_time = start_time,
              end_time   = Sys.time(),
              n          = counter
            )
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
        consume_loop_batch =
          function (
            expr = expression(print(msgs)),
            check = expression(TRUE)
          ) {

            start_time <- Sys.time()
            counter    <- 0


            # loop while check evaluates to TRUE
            while ( eval(check) ){

              # poll for new messages
              n <- self$poll()

              # check if new messages were received
              if ( n > 0 ){

                # retrieve bulk of messages and loop over them one by one
                records <- self$records()

                # extract single message and process it
                msgs <- records
                eval(expr)

                # update counter
                counter <- counter + n
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
        subscribe =
          function(topics) {
            topics_string_array <- .jarray(topics)
            self$java_consumer$subscribe(topics_string_array)
          },



        #'
        #' @description
        #' List current subscription
        #'
        subscription =
          function() {
            self$java_consumer$subscription()
          }
      ),

    #### private ###############################################################

    private = NULL
  )
