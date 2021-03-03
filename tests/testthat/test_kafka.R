context("2 Basic Kafka Interaction")



skip_if_kafka_on_is_missing <- function ()
{
  if ( Sys.getenv("KAFKA_IS_ON") != 'true' ) {
    skip("Skipped: EnvVar 'KAFKA_IS_ON' is != 'true' ")
  }
}


test_that(
  desc = "Start/End/Running",
  code =
    {


      skip_if_kafka_on_is_missing()

      consumer <- kafka_consumer()
      consumer$start()

      # running after startup?
      expect_true(consumer$running())


      # not running after shutdown?
      expect_false(consumer$end()$running())

    }
)

test_that(
  desc = "Props",
  code =
    {


      skip_if_kafka_on_is_missing()

      consumer <- kafka_consumer()
      consumer$start()


      # props exists?
      expect_true("list" %in% class(consumer$props()))
      expect_true( length(consumer$props()) > 0)

      # setting props works?
      consumer$props(max.poll.records = 200)
      expect_true(consumer$props()$max.poll.records == "200")

      # setting props via list works
      consumer$props( .properties = list(max.poll.records = 333, a = 47) )
      expect_true(
        consumer$props()$max.poll.records == "333" &
        consumer$props()$a == "47"
      )
    }
)


test_that(
  desc = "Consumer topic list",
  code =
    {

      skip_if_kafka_on_is_missing()

      consumer <- kafka_consumer()
      consumer$start()

      # check if test topics are present
      expect_true(
        length(consumer$topics_list()) >= 4
      )

      # check defaults to topic list names only
      expect_true(
        "character" %in% class(consumer$topics_list())
      )


      # check that full=TRUE gives more infos
      expect_true(
        "list" %in% class(consumer$topics_list(full = TRUE))
      )
      expect_true(
        "data.frame" %in% class(consumer$topics_list(full = TRUE)[[1]])
      )

    }
)
