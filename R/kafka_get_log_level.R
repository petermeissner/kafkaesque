#' Retrieving Current Java Log Level
#'
#' @export
#'
#' @examples
#'
#' kafka_get_log_level()
#'
#'
kafka_get_log_level <-
  function(){
    logger <- rJava::.jnew("kafkaesque/Kafka_logger")
    logger$get_log_level()
  }
