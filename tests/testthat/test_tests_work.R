context("1 Trivial")

# skip_if_kafka_on_is_missing <- function ()
# {
#   if ( Sys.getenv("KAFKA_IS_ON") != 'true' ) {
#     skip("Skipped: EnvVar 'KAFKA_IS_ON' is != 'true' ")
#   }
# }




test_that(
  desc = "create consumer",
  code =
    {
      # skip_if_kafka_on_is_missing()

      consumer <- kafka_consumer()

      # starting/connecting - + status
      consumer$start()

      expect_true({
        consumer$running()
      })

      expect_false({
        consumer$end()$running()
      })

      expect_true({
        consumer$start()$running()
      })
    }
)
