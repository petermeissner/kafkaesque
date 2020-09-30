#' R6 Class for Kafka Records
#'
#' This class will handle kafka records.
#' It allows to manage polling for new messages, retrieval of messages from JVM,
#' local storage of message batches and iteration and forwarding messages or
#' message batches for consumption.
#'
#' It abstracts storage, polling, forwarding into an iteratable interface where
#' messages can be accessed via \code{next_record()} and \code{next_record_batch()}.
#'
#' @import data.table
#' @import jsonlite
#' @import rJava
#'
#' @export
#'
kafka_records_class <-
  R6::R6Class(

    #### options ###############################################################
    classname = "kafka_class_consumer",
    portable = TRUE,
    parent_env = asNamespace("kafkaesque"),

    #### public ###############################################################

    public = list(

      #'
      #' @description
      #'
      #'
      #'
      initialize =
        function ( parent ) {
          private$parent <- parent
        },


      #'
      #' @description
      #'
      #'
      #'
      records_df =
        function(){
          private$records
        },


      #'
      #' @description
      #'
      #'
      #'
      next_record =
        function(){

          # need to get new records or not?
          while ( nrow(private$records) == 0L || private$records_pointer == nrow(private$records) ){
            # get new records and reset records pointer
            private$new_records()
            private$records_pointer <- 0L
          }

          # increase records pointer and return next item
          private$records_pointer <- private$records_pointer + 1L
          private$records[private$records_pointer, ]
        },


      #'
      #' @description
      #'
      #'
      #'
      #'
      next_record_batch =
        function(){

          # need to get new records or not?
          while ( nrow(private$records) == 0L || private$records_pointer == nrow(private$records) ){
            # get new records and reset records pointer
            private$new_records()
            private$records_pointer <- 0L
          }

          # increase records pointer and return next batch of items
          private$records_pointer <- as.integer(nrow(private$records))
          private$records[seq(from = private$records_pointer, to = nrow(private$records)), ]
        }

    ),



    #### private ###############################################################

    private =
      list(

        #' Reference to consumer object that serves as parent.
        #'
        parent          = list(),

        #' Holds a batch of messages received from kafka consumer as data.frame
        #' or data.table.
        #'
        records         = data.frame(),

        #' Records which message from local storage records is to be consumed next
        #'
        records_pointer = 0L,

        #' Use poll method on kafka consumer to get new messages.
        #'
        new_records =
          function(){

            # kafka poll for new messages
            private$parent$poll()

            # transform records from Java to R
            private$records <-
              data.table::rbindlist(
                lapply(
                  X =
                    jsonlite::fromJSON(
                      iconv(
                        x = private$parent$java_consumer$records_json(),
                        to = "UTF-8"
                      )
                    )$records,

                  FUN =
                    function(x){
                      # get rid of nested headers data.frame
                      x <- x[, -c(which(names(x) %in% "headers"))]

                      # unnest leader epoch
                      x$leaderEpoch <- x$leaderEpoch$value

                      # return
                      x
                    }
                )
              )
          }
      )

  )