#' Constructor for kafka_class_producer
#'
#' @export
#'
#' @examples
#'
#' producer <- kafka_admin()
#'
#' @seealso \link{kafka_admin_class}
#'
kafka_admin <-
  function(){
    kafka_admin_class$new()
  }