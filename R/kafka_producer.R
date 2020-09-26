
#' kafka_producer
#'
#' Initializes and returns object of class = "kafka_producer", "R6".
#' Messages can be all types of R-objects. These will be serialized to JSON
#' before sending.
#' @param brokerList the list of brokers to produce to
#' @param topic the topic to use for messages
#' @param type the type - think subtopic - of a message
#' @param keySerializerClass kafka key serializer class
#' @param valueSerializerClass kafka value serializer class
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'  pr <- kafka_producer_new(topic = "test")
#'  pr$send_message("1", type = "number")
#'  pr$send_message("2")
#'  pr$send_message("3")
#'  pr$send_message(data.frame(a = 1:10, b = "foo"), type = "data")
#'  pr$send_message(data.frame(a = 1:10, b = "foo"), type = "gubbelgigoo")
#' }
#'
#' @import rJava
#'
kafka_producer <-
  function(
    brokerList = "localhost:9092",
    topic = "test",
    type = "undefined",
    keySerializerClass = "org.apache.kafka.common.serialization.StringSerializer",
    valueSerializerClass = "org.apache.kafka.common.serialization.StringSerializer"
  ){
    kafka_producer_class$new(
      brokerList = brokerList,
      topic = topic,
      type  = type,
      keySerializerClass = keySerializerClass,
      valueSerializerClass = valueSerializerClass
    )
  }

