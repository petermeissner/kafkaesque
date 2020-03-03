
context("2 Java")

test_that(
  "one plus one is two",
  {
    test_method_call <-
      function(){
        message("JAVA_HOME: ", Sys.getenv("JAVA_HOME"))
        tmp <- rJava::.jnew("kafkaesque.App")
        tmp$test_method()
      }
  }
)



