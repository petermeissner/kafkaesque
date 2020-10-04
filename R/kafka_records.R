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
      #'
      #' @param parent enclosing consumer object
      #'
      #' @description
      #'
      #' Create a new instance of class
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

          # extract next batch
          res <- private$records[seq(from = private$records_pointer + 1L, to = nrow(private$records)), ]

          # increase records pointer and return next batch of items
          private$records_pointer <- as.integer(nrow(private$records))

          # return
          res
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

            # transform collection of messages into collection of arrays to make
            # transformation from Java to R easier
            obj <- consumer$java_consumer$records_arrays()


            # transform records from Java to R
            private$records <-
              data.table::as.data.table(
                list(
                  topic               = obj$topic,
                  key                 = obj$keys,
                  partition           = obj$partitions,
                  offset              = obj$offsets,
                  timestamp           = obj$timestamp,
                  value               = obj$values,
                  timestampType       = obj$timestampType,
                  leaderEpoch         = obj$leaderEpoch,
                  serializedKeySize   = obj$serializedKeySize,
                  serializedValueSize = obj$serializedValueSize
                )
              )
          }
      )

  )


#' Constructor for kafka_records_class
#'
#' @param parent enclosing consumer object
#'
kafka_records <-
  function(parent){
    kafka_records_class$new(parent = parent)
  }