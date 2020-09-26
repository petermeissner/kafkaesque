

#' java_class
#'
#' @param object_ref
#'
#' @export
#'
java_class <-
  function(object_ref){
    rJava::.jcall(
      obj       = "kafkaesque/Kafka_helper",
      returnSig = "V",
      method    = "print_class",
      rJava::.jcast(object_ref)
    )
  }


#' java_methods
#'
#' @param object_ref
#'
#' @export
#'
java_methods <-
  function(object_ref){
    rJava::.jcall(
      obj       = "kafkaesque/Kafka_helper",
      returnSig = "V",
      method    = "print_methods",
      rJava::.jcast(object_ref)
    )
  }