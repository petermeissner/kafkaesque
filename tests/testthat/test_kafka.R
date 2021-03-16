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





test_that(
  desc = "Consumer polling for messages",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()


      # consume messages and expect timout to not significantly be crossed
      cns$topics_subscribe("test500000")

      for ( i in 1:100 ){
        expect_true(as.numeric(system.time(cns$poll(1000))["elapsed"]) < 1.1 )
      }

      for ( i in 1:100 ){
        expect_true(
          as.numeric(system.time(cns$poll(100))["elapsed"]) < 0.2
        )
      }


      # use commit and expect no error
      for ( i in 1:100 ){

        cns$props()
        cns$topics_offsets()
        cns$poll(100)
        cns$commit()
        cns$topics_offsets()

      }
      expect_true(TRUE)

    }
)





<<<<<<< HEAD

test_that(
  desc = "Consumer use consume_loop",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()
      cns$topics_subscribe("test500000")


      lst <- vector(mode = "list", 100)
      cns_lp <-
        cns$consume_loop(
          expr  = expression(lst[[ loop_counter ]] <<- messages),
          check = expression( loop_counter < 100 )
        )

      expect_true(
        length(lst) == 100
      )

      expect_true(
        {
          all(
            vapply(
              X         = lst,
              FUN       = function(x){"data.frame" %in% class(x)},
              FUN.VALUE = TRUE
            )
          )
        }
      )

    }
)



test_that(
  desc = "Consumer use consume_loop with timeout",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()
      cns$topics_subscribe("test500000")


      lst <- vector(mode = "list", 100)
      cns_lp <-
        cns$consume_loop(
          expr      = expression(lst[[ loop_counter ]] <<- messages),
          check     = expression( loop_counter < 100 ),
          timout_ms = 500
        )

      expect_true(
        length(lst) == 100
      )

      expect_true(
        {
          all(
            vapply(
              X         = lst,
              FUN       = function(x){"data.frame" %in% class(x)},
              FUN.VALUE = TRUE
            )
          )
        }
      )

    }
)

=======
#
# test_that(
#   desc = "Consumer use consume_loop",
#   code =
#     {
#
#       skip_if_kafka_on_is_missing()
#
#       cns <- kafka_consumer()
#       cns$start()
#
#       lst <- vector(mode="list", 100)
#       cns_lp <-
#         cns$consume_loop(
#           expr  = expression(lst[[counter+1]] <<- msgs),
#           check = expression(counter < 100)
#         )
#
#
#       # consume messages and expect timout to not significantly be crossed
#       cns$topics_subscribe("test500000")
#
#       for ( i in 1:100 ){
#         expect_true(as.numeric(system.time(cns$poll(1000))["elapsed"]) < 1.1 )
#       }
#
#       for ( i in 1:100 ){
#         expect_true(
#           as.numeric(system.time(cns$poll(100))["elapsed"]) < 0.2
#         )
#       }
#
#
#       # use commit and expect no error
#       for ( i in 1:100 ){
#
#         cns$props()
#         cns$topics_offsets()
#         cns$poll(100)
#         cns$commit()
#         cns$topics_offsets()
#
#       }
#       expect_true(TRUE)
#
#     }
# )
>>>>>>> e7b3067852b0ee5529fb3b01f60ecb42ac8fcc56




<<<<<<< HEAD
test_that(
  desc = "Consumer use consume_loop in batches",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()
      cns$topics_subscribe("test500000")


      lst <- vector(mode = "list", 100)
      cns_lp <-
        cns$consume_loop(
          expr  = expression(lst[[ loop_counter ]] <<- messages),
          check = expression( loop_counter < 100 ),
          batch = TRUE
        )

      expect_true(
        length(lst) == 100
      )

      expect_true(
        {
          all(
            vapply(
              X         = lst,
              FUN       = function(x){"data.frame" %in% class(x)},
              FUN.VALUE = TRUE
            )
          )
        }
      )

    }
)





test_that(
  desc = "Consumer use consume_loop in batches",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()
      cns$topics_subscribe("test500000")


      timing <-
        system.time({
          lst <- vector(mode = "list", 100)
          cns_lp <-
            cns$consume_loop(
              expr       = expression(lst[[ loop_counter ]] <<- messages),
              check      = expression( message_counter < 400000 ),
              batch      = TRUE,
              timeout_ms = 10000
            )
        })


      expect_true(
        as.integer(timing['elapsed']) < 20
      )

      expect_true(
        length(lst) == 100
      )

      expect_true(
        {
          all(
            vapply(
              X         = lst,
              FUN       = function(x){"data.frame" %in% class(x)},
              FUN.VALUE = TRUE
            )
          )
        }
      )

    }
)


=======
>>>>>>> e7b3067852b0ee5529fb3b01f60ecb42ac8fcc56


















