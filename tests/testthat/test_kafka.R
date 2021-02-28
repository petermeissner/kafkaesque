context("2 Basic Kafka Interaction")



skip_if_kafka_on_is_missing <- function ()
{
  if ( Sys.getenv("KAFKA_IS_ON") != 'true' ) {
    skip("Skipped: EnvVar 'KAFKA_IS_ON' is != 'true' ")
  }
}


test_that(
  desc = "Start consumer and read",
  code =
    {


      skip_if_kafka_on_is_missing()

      consumer <- kafka_consumer()
      consumer$start()

      # running after startup?
      expect_true(consumer$running())


      # props exists?
      expect_true("list" %in% class(consumer$props()))
      expect_true( length(consumer$props()) > 0)

      # setting props works?
      consumer$props(max.poll.records = 200)
      expect_true(consumer$props()$max.poll.records == "200")

      # not running after shutdown?
      expect_false(consumer$end()$running())

    }
)


test_that(
  desc = "Start consumer and read",
  code =
    {

      skip_if_kafka_on_is_missing()

      consumer <- kafka_consumer()
      consumer$start()


      # running after startup?
      expect_true(consumer$start()$running())

      expect_true(
        length(consumer$topics_list()) > 0
      )


    }
)
