#' #' Title
#' #'
#' #' @param version version string to install
#' #' @param path path to install to
#' #'
#' #' @return Nothing, called for side effect: Installation of Kafka.
#' #'
#' #' @export
#' #'
#' #' @examples
#' #'
#' #' \dontrun{
#' #' kafka_install_kafka(version = "2.3.2", path = "./kafka")
#' #' }
#' #'
#' kafka_install_kafka <-
#'   function(version = "2.3.1", path = NULL){
#'
#'     # check path parameter
#'     if ( is.null(path) ) {
#'       stop("Please provide path to install kafka into.")
#'     } else {
#'       if ( file.exists(path) ) {
#'         stop("Installation path exists already. I will not override any existing directory.")
#'       }
#'     }
#'
#'     # get available versions from
#'     http_dir_main <- jsonlite::fromJSON("https://api.github.com/repos/petermeissner/kafka-portable/git/trees/main")
#'     http_paths    <- http_dir_main$tree$path
#'     versions      <- gsub(x = http_paths, pattern = "kafka_\\d+\\.\\d+-", replacement = "")
#'
#'
#'     # check version parameter
#'     if ( is.null(version) ){
#'       message("Available Kafka versions: ", paste(versions, collapse = ", "))
#'     } else if ( !(version %in% versions) ){
#'       message("Available Kafka versions: ", paste(versions, collapse = ", "))
#'       stop(sprintf("Selected version (%s) not available.", version))
#'     }
#'
#'     #
#'
#'
#'   }