
#' R6 Class for Kafka Admin
#'
#' @import data.table
#' @import jsonlite
#' @import rJava
#'
#' @export
#'
kafka_admin_class <-
  R6::R6Class(

    #### options ###############################################################
    classname = "kafka_admin_class",

    portable = TRUE,

    parent_env = asNamespace("kafkaesque"),




    #### public ################################################################

    public =
      list(

        ## data ################################################################

        #' @field java_admin reference to the underlying Java object
        java_admin = list(),



        ## methods #############################################################

        #' Initialize
        #'
        #' @description
        #' Create a new admin object.
        #' Instead of \code{kafka_admin_class$new()} one can use \code{kafka_admin()}
        #'
        #' @return returns object reference for method chaining
        #'
        initialize =
          function() {
            self$java_admin <- rJava::.jnew("kafkaesque/Kafka_admin")
          },


        #'
        #' @description
        #' Code run when object is removed from session
        #'
        finalize =
          function() {
            self$java_admin$end()
          },


        #'
        #' @description
        #' Spin up admin and connect it to Kafka cluster
        #'
        #' @return returns object reference for method chaining
        #'
        start =
          function() {
            self$java_admin$start()

            # return for method chaining
            invisible(self)
          },


        #'
        #' @description
        #' Disconnect admin from Kafka cluster
        #'
        #' @return returns object reference for method chaining
        #'
        end =
          function() {
            self$java_admin$end()

            # return for method chaining
            invisible(self)
          },

        #'
        #' @description
        #' Disconnect and reconnect admin from Kafka cluster
        #'
        #' @return returns object reference for method chaining
        #'
        restart =
          function() {
            self$java_admin$restart()

            # return for method chaining
            invisible(self)
          },


        #'
        #' @description
        #' Whether or not admin is active (has been started or not)
        #'
        #' @return TRUE/FALSE
        #'
        running =
          function() {
            self$java_admin$running
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
              self$java_admin$props_set(
                .jcastToArray(names(.properties)),
                .jcastToArray(format(.properties, scientific = FALSE))
              )
            } else if ( length(list(...)) > 0 ){
              .properties <- list(...)
              self$java_admin$props_set(
                .jcastToArray(names(.properties)),
                .jcastToArray(format(.properties, scientific = FALSE))
              )
            }

            # return properties
            jsonlite::fromJSON(
              iconv(
                x  = self$java_admin$props$to_json(),
                to = "UTF-8"
              )
            )
          },

        #'
        #' @description
        #' Query and return list of topics.
        #'
        #'
        #' @return returns a character vector of topics
        #'
        #'
        topics_list =
          function() {
            self$java_admin$topics_list()
          }



      ),

    #### private ###############################################################

    private = NULL
  )
