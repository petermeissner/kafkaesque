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
#' The main problem here is that message consumption is not trivial for a couple
#' of reasons: (1) The R interface has to be in sync with the Java side of things
#' - there is an records object at the Java side.
#' (2) Kafka does fetch messages in batches. While batches might be as small as
#' 0 or 1 message the default is to consume messages in batches of 500. This
#' makes consuming single messages a non trivial process since the batch size
#' is determined by how the consumer options were set e.g. timeouts and max
#' fetch sizes the number of available messages on the topic - all things
#' outside the s specific call of the poll method which executes data retrieval.
#' (3) Extra processing has to be done to translate records from Java into R.
#'
#' @import data.table
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
      #' @param timeout_ms defaults to `Inf`.
      #'   Time for which poll will wait for data
      #'   Passed through to kafka_consumer$poll()
      #'
      #' @description
      #'
      #' Returns the next record ready for consumption. If the last poll returned
      #' a batch of messages one of those will be returned one after another.
      #' If all of these have been returned already a new poll will be initiated.
      #'
      #' If the poll does not return any records a new poll will be initiated
      #' until data is returned.
      #'
      next_record =
        function(timeout_ms = Inf){

          # need to get new records or not?
          while ( nrow(private$records) == 0L || private$records_pointer == nrow(private$records) ){
            # get new records and reset records pointer
            private$new_records(timeout_ms = timeout_ms)
            private$records_pointer <- 0L
          }

          # increase records pointer and return next item
          private$records_pointer <- private$records_pointer + 1L
          private$records[private$records_pointer, ]
        },


      #'
      #' @description
      #'
      #' @param timeout_ms defaults to `Inf`.
      #'   Time for which poll will wait for data
      #'   Passed through to kafka_consumer$poll()
      #'
      #' Returns all available, unconsumed messages. If no unconsumed messages
      #' are available it will poll for a new batch and return it.      #'
      #'
      #' If the poll does not return any records a new poll will be initiated
      #' until data is returned.
      #'
      next_record_batch =
        function(timeout_ms = Inf){

          # need to get new records or not?
          while ( nrow(private$records) == 0L || private$records_pointer == nrow(private$records) ){
            # get new records and reset records pointer
            private$new_records(timeout_ms = timeout_ms)
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
          function(timeout_ms){

            # kafka poll for new messages
            private$parent$poll(timeout_ms = timeout_ms )

            # transform collection of messages into collection of arrays to make
            # transformation from Java to R easier
            obj <- private$parent$java_consumer$records_arrays()


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
