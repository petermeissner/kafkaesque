#' kafka_set_log_level
#'
#' @param log_level [character] indicating the the log level to use:
#'     TRACE, DEBUG, INFO, WARN, ERROR
#'
#' @export
#'
#' @examples
#'
#' kafka_set_log_level("info")
#'
#'
kafka_set_log_level <-
  function(log_level = NULL){

    # set log level if any log level was passed
    if ( !is.null(log_level) ){
      log_level <- tolower(log_level)
      logger <- rJava::.jnew("kafkaesque/Kafka_logger")
      logger$set_log_level(log_level)
    }

    # return current level
    logger$get_log_level()
  }
