kafka_class_producer <-
  R6::R6Class(

    #### options ###############################################################

    classname  = "kafka_class_producer",

    portable   = TRUE,

    parent_env = asNamespace('kafkaesque'),




    #### public ################################################################

    public =
      list(

        ## data ################################################################
        topic           = "",
        type            = "",
        kafka_producer = list(),



        ## methods #############################################################

        ## - M - initialize ####################################################
        initialize =
          function (
            brokerList = "localhost:9092",
            topic = "test",
            type = "undefined",
            keySerializerClass = "org.apache.kafka.common.serialization.StringSerializer",
            valueSerializerClass = "org.apache.kafka.common.serialization.StringSerializer"
          ) {

            # create
            self$kafka_producer <-
              kafkaesque::kafkaesque.createProducer(
                metadataBrokerList   = brokerList,
                keySerializerClass   = keySerializerClass,
                valueSerializerClass = valueSerializerClass
              )

            self$topic <- topic
          },


        ## - M - finalize ######################################################
        finalize =
          function ( ) {
            kafkaesque::kafkaesque.closeProducer(self$kafka_producer)
          },

        ## - M - send_message ##################################################
        send_message =
          function(
            data  = list(),
            txt   = "",
            topic = self$topic,
            type  = self$type
          ){

            # add time stamp to msg
            msg <-
              list(
                data = data,
                txt  = txt,
                type = type,
                ts   = kafka_time_stamp()
              )

            # send message and suppress stupid infos getting printed again and again
            capture.output({
              kafkaesque::kafkaesque.send(
                producer  = self$kafka_producer,
                topicName = topic,
                message   = jsonlite::toJSON(msg)
              )
            })

            # return - without printing
            invisible(msg)
          },

        ## - M - send_message_with_partition ###################################
        send_message_with_partition =
          function(
            data  = list(),
            txt   = "",
            partition = partition,
            topic = self$topic,
            type  = self$type,
            key   = "NULL"
          ){

            # add time stamp to msg
            msg <-
              list(
                data = data,
                txt  = txt,
                type = type,
                ts   = kafka_time_stamp()
              )

            # send message and suppress stupid infos getting printed again and again
            capture.output({
              kafkaesque::kafkaesque.sendWithPartition(
                producer  = self$kafka_producer,
                topicName = topic,
                partition = partition,
                message   = jsonlite::toJSON(msg),
                key       = "NULL"
              )
            })

            # return - without printing
            invisible(msg)
          }
      ),

    #### private ###############################################################

    private = NULL
  )













