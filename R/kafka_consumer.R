#' Constructor for kafka_class_consumer
#'
#' @export
#'
#' @examples
#'
#' consumer <- kafka_consumer()
#'
kafka_consumer <-
  function(){
    kafka_class_consumer$new()
  }