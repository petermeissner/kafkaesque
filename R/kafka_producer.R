#' Constructor for kafka_class_producer
#'
#' @export
#'
#' @examples
#'
#' producer <- kafka_producer()
#'
#' @seealso \link{kafka_producer_class}
#'
kafka_producer <-
  function(){
    kafka_producer_class$new()
  }