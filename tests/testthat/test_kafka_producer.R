context("Kafka Producer")



skip_if_kafka_on_is_missing <- function ()
{
  if ( Sys.getenv("KAFKA_IS_ON") != 'true' ) {
    skip("Skipped: EnvVar 'KAFKA_IS_ON' is != 'true' ")
  }
}


test_that(
  desc = "Starting and Stoping",
  code =
    {

      skip_if_kafka_on_is_missing()

      prd <- kafka_producer()

      prd$start()
      expect_true(
        prd$running() == TRUE
      )

      prd$end()
      expect_true(
        prd$running() == FALSE
      )

      prd$restart()
      expect_true(
        prd$running() == TRUE
      )

    }
)




test_that(
  desc = "Props",
  code =
    {

      skip_if_kafka_on_is_missing()

      prd <- kafka_producer()

      prd$start()

      # check props return
      lst <- prd$props()
      expect_true(
        inherits(lst, "list")
      )

      # check props set
      prd$props(whatever.you.may.want.to.set = "true")
      expect_true(
        prd$props()[['whatever.you.may.want.to.set']] == "true"
      )

      prd$props(.properties = list(a=1, b = 2))
      expect_true(
        prd$props()[['a']] == "1"
      )
      expect_true(
        prd$props()[['b']] == "2"
      )
    }
)


test_that(
  desc = "Topic Send Messages",
  code =
    {

      skip_if_kafka_on_is_missing()

      prd <- kafka_producer()
      adm <- kafka_admin()
      cns <- kafka_consumer()

      prd$start()
      adm$start()
      cns$start()

      tpc_lst <-
        adm$topics_create(
          topic              = "test_producer",
          partition          = c(1L),
          replication_factor = c(1L)
        )

      cns$topics_subscribe("test_producer")
      prd$send("test_producer", "ola")
      prd$send("test_producer", "oha")
      prd$send("test_producer", "haha")



      expect_true(
        cns$consume_next()$value == "ola"
      )
      expect_true(
        cns$consume_next()$value == "oha"
      )
      expect_true(
        cns$consume_next()$value == "haha"
      )

    }
)


