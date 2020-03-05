
#' R6 Class for Kafka Consumer
#'
#' @export
#'
kafka_class_consumer <-
  R6::R6Class(

    #### options ###############################################################

    classname  = "kafka_class_consumer",

    portable   = TRUE,

    parent_env = asNamespace('kafkaesque'),




    #### public ################################################################

    public =
      list(

        ## data ################################################################

        #' @field cons reference to the underlying Java object
        cons = list(),



        ## methods #############################################################

        #'
        #' @description
        #' Create a new consumer object
        #'
        initialize =
          function(){
            self$cons <- rJava::.jnew("kafkaesque/Kafka_consumer")
          },


        #'
        #' @description
        #' Code run when object is removed from session
        #'
        finalize =
          function ( ) {
              self$cons$end()
          },


        #'
        #' @description
        #' Spin up consumer and connect it to Kafka cluster
        #'
        start =
          function ( ) {
            self$cons$start()
          },


        #'
        #' @description
        #' Disconnect consumer from Kafka cluster
        #'
        end =
          function ( ) {
            browser()
          },


        #'
        #' @description
        #' Polling for messages
        #'
        poll =
          function(
          ){
              browser()
          },


        #'
        #' @description
        #' Subscribe to one or more topics
        #'
        #' @param topics character vector defining topics or topic regex to subscribe to
        #'
        subscribe =
          function(topics){
            topics_string_array <- .jarray(topics)
            self$cons$subscribe(topics_string_array)
          },



        #'
        #' @description
        #' List current subscription
        #'
        subscription =
          function(){
            self$cons$subscription()
          }

      ),

    #### private ###############################################################

    private = NULL
  )













