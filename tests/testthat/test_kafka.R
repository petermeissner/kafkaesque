context("2 Basic Kafka Interaction")



skip_if_kafka_on_is_missing <- function ()
{
  if ( Sys.getenv("KAFKA_IS_ON") != 'true' ) {
    skip("Skipped: EnvVar 'KAFKA_IS_ON' is != 'true' ")
  }
}


test_that(
  desc = "Consumer seeking",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()

      # single subscription
      cns$start()
      cns$topics_subscribe("test500000")


      # seek to beginning and read
      cns$topics_seek_to_beginning()

      # check for content retrieved
      d <- cns$consume_next()
      expect_true(!is.null(d))


      # consume some and seek to start again
      cns$consume_next()
      cns$consume_next()

      cns$topics_seek_to_beginning()
      expect_true(
        cns$topics_offsets()$offset == 0
      )


      # seek to end works
      cns$topics_seek_to_end()
      expect_true(
        cns$topics_offsets()$offset == 500000
      )


      # seek to start yet again
      cns$topics_seek_to_beginning()
      expect_true(
        cns$topics_offsets()$offset == 0
      )



    }
)







test_that(
  desc = "Start/End/Running",
  code =
    {


      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()

      # running after startup?
      expect_true(cns$running())


      # not running after shutdown?
      expect_false(cns$end()$running())

    }
)

test_that(
  desc = "Props",
  code =
    {


      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()


      # props exists?
      expect_true("list" %in% class(cns$props()))
      expect_true( length(cns$props()) > 0)

      # setting props works?
      cns$props(max.poll.records = 200)
      expect_true(cns$props()$max.poll.records == "200")

      # setting props via list works
      cns$props( .properties = list(max.poll.records = 333, a = 47) )
      expect_true(
        cns$props()$max.poll.records == "333" &
          cns$props()$a == "47"
      )
    }
)


test_that(
  desc = "Consumer topic list",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()

      # check if test topics are present
      expect_true(
        length(cns$topics_list()) >= 4
      )

      # check defaults to topic list names only
      expect_true(
        "character" %in% class(cns$topics_list())
      )


      # check that full=TRUE gives more infos
      expect_true(
        "list" %in% class(cns$topics_list(full = TRUE))
      )
      expect_true(
        "data.frame" %in% class(cns$topics_list(full = TRUE)[[1]])
      )

    }
)




test_that(
  desc = "Consumer topic subscription",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()


      # empty subscription on startup
      expect_true(
        length(cns$topics_subscription()) == 0
      )


      # single subscription
      cns$topics_subscribe("test3")
      expect_true(
        cns$topics_subscription() == "test3"
      )


      # replaced subscription
      cns$topics_subscribe(c("test", "test2"))
      expect_true(
        all(c("test", "test2") %in% cns$topics_subscription())
      )


      # no subscription at all
      cns$topics_subscribe(character())
      expect_true(
        length(cns$topics_subscription()) == 0
      )

    }
)





















