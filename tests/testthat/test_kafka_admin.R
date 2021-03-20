context("Kafka Admin")



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

      adm <- kafka_admin()

      adm$start()
      expect_true(
        adm$running() == TRUE
      )

      adm$end()
      expect_true(
        adm$running() == FALSE
      )

      adm$restart()
      expect_true(
        adm$running() == TRUE
      )

      # check props return
      lst <- adm$props()
      expect_true(
        inherits(lst, "list")
      )

      # check props set
      adm$props(whatever.you.may.want.to.set = "true")
      expect_true(
        adm$props()[['whatever.you.may.want.to.set']] == "true"
      )
    }
)




test_that(
  desc = "Props",
  code =
    {

      skip_if_kafka_on_is_missing()

      adm <- kafka_admin()

      adm$start()

      # check props return
      lst <- adm$props()
      expect_true(
        inherits(lst, "list")
      )

      # check props set
      adm$props(whatever.you.may.want.to.set = "true")
      expect_true(
        adm$props()[['whatever.you.may.want.to.set']] == "true"
      )

      adm$props(.properties = list(a=1, b = 2))
      expect_true(
        adm$props()[['a']] == "1"
      )
      expect_true(
        adm$props()[['b']] == "2"
      )
    }
)


test_that(
  desc = "Topic Creation and Deletion",
  code =
    {

      skip_if_kafka_on_is_missing()

      adm <- kafka_admin()

      adm$start()



      tpc_lst <- adm$topics_list()
      expect_true(
        all(
          c("test500000", "test2", "test3", "test") %in% tpc_lst
        )
      )


      topics <- c("chuckle", "chit_chat")

      tpc_lst <-
        adm$topics_create(
          topic              = topics,
          partition         = c(1L, 1L),
          replication_factor = c(1L, 1L)
        )

      expect_true(
        all(
          c("chuckle", "chit_chat") %in% tpc_lst
        )
      )

      tpc_lst <- adm$topics_list()
      expect_true(
        all(
          c("chuckle", "chit_chat") %in% tpc_lst
        )
      )

      tpc_lst <- adm$topics_list()
      expect_true(
        all(
          c("test500000", "test2", "test3", "test") %in% tpc_lst
        )
      )



      adm$topics_delete(topics)
      tpc_lst <- adm$topics_list()
      expect_true(
        all(
          !(c("chuckle", "chit_chat") %in% tpc_lst)
        )
      )
      expect_true(
        all(
          c("test500000", "test2", "test3", "test") %in% tpc_lst
        )
      )


    }
)


