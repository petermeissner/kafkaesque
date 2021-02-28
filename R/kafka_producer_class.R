
#' R6 Class for Kafka Producer
#'
#' @import data.table
#' @import jsonlite
#' @import rJava
#'
#' @export
#'
kafka_producer_class <-
  R6::R6Class(

    #### options ###############################################################
    classname = "kafka_producer_class",

    portable = TRUE,

    parent_env = asNamespace("kafkaesque"),




    #### public ################################################################

    public =
      list(

        ## data ################################################################

        #' @field java_producer reference to the underlying Java object
        java_producer = list(),



        ## methods #############################################################

        #' Initialize
        #'
        #' @description
        #' Create a new producer object.
        #' Instead of \code{kafka_producer_class$new()} one can use \code{kafka_producer()}
        #'
        #' @return \code{self} for method chaining
        #'
        initialize =
          function() {
            self$java_producer <- rJava::.jnew("kafkaesque/Kafka_producer")
          },


        #'
        #' @description
        #' Code run when object is removed from session
        #'
        finalize =
          function() {
            self$java_producer$end()
          },


        #'
        #' @description
        #' Spin up producer and connect it to Kafka cluster
        #'
        #' @return \code{self} for method chaining
        #'
        start =
          function() {
            self$java_producer$start()

            # return for method chaining
            invisible(self)
          },


        #'
        #' @description
        #' Disconnect producer from Kafka cluster
        #'
        #' @return \code{self} for method chaining
        #'
        end =
          function() {
            self$java_producer$end()

            # return for method chaining
            invisible(self)
          },

        #'
        #' @description
        #' Disconnect and reconnect producer from Kafka cluster
        #'
        #' @return \code{self} for method chaining
        #'
        restart =
          function() {
            self$java_producer$restart()

            # return for method chaining
            invisible(self)
          },


        #'
        #' @description
        #' Whether or not producer is active (has been started or not)
        #'
        #' @return TRUE/FALSE
        #'
        running =
          function() {
            self$java_producer$running
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
              self$java_producer$props_set(
                .jcastToArray(names(.properties)),
                .jcastToArray(format(.properties, scientific = FALSE))
              )
            } else if ( length(list(...)) > 0 ){
              .properties <- list(...)
              self$java_producer$props_set(
                .jcastToArray(names(.properties)),
                .jcastToArray(format(.properties, scientific = FALSE))
              )
            }

            # return properties
            jsonlite::fromJSON(
              iconv(
                x  = self$java_producer$props$to_json(),
                to = "UTF-8"
              )
            )
          },

        #'
        #'
        #' @param topic topic to send messaged to
        #' @param msg message to be send or character vector of messages to be send
        #' @param key TBD
        #' @param partition  TBD
        #'
        #' @description
        #'
        #' @return returns self for method chaining
        #'
        #'
        send =
          function(topic, msg, key = NULL, partition = NULL){

            #### TODO
            if( !is.null(key) || !is.null(partition)){
              message("TBD")
              return()
            }

            # send
            self$java_producer$send_message(topic, msg)
          }

      ),

    #### private ###############################################################

    private = NULL
  )
