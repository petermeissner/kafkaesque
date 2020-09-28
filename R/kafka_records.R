#' R6 Class for Kafka Records
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

      initialize =
        function ( parent ) {
          private$parent <- parent
        },

      records_df =
        function(){
          private$records
        },

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
        parent          = list(),

        records         = data.frame(),
        records_pointer = 0L,

        new_records =
          function(){
            private$parent$poll()
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