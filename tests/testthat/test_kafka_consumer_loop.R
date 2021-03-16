
context("Kafka Consumer Loop")

skip_if_kafka_on_is_missing <- function ()
{
  if ( Sys.getenv("KAFKA_IS_ON") != 'true' ) {
    skip("Skipped: EnvVar 'KAFKA_IS_ON' is != 'true' ")
  }
}



test_that(
  desc = "Consumer use consume_loop",
  code =
    {

      skip_if_kafka_on_is_missing()

      cns <- kafka_consumer()
      cns$start()
      cns$topics_subscribe("test500000")


      lst <- vector(mode = "list", length = 100)


      res <-
        cns$consume_loop(
          f     = function(loop_env){ loop_env[[as.character(loop_env$meta$loop_counter)]] <- "wtf" },
          check = function(loop_env){ loop_env$meta$loop_counter < 100 },
          batch = TRUE
        )

      expect_true({
        all(as.character(1:100) %in% names(res))
      })

      res2 <-
        cns$consume_loop(
          check      = function(loop_env){ loop_env$meta$loop_counter < 100 },
          batch      = FALSE,
          timeout_ms = 1000
        )

      expect_true({
        res$meta$loop_counter == 100
      })

    }
)



# test_that(
#   desc = "Consumer use consume_loop with timeout",
#   code =
#     {
#
#       skip_if_kafka_on_is_missing()
#
#       cns <- kafka_consumer()
#       cns$start()
#       cns$topics_subscribe("test500000")
#
#
#       lst <- vector(mode = "list", length = 100)
#       cns_lp <-
#         cns$consume_loop(
#           expr       = expression(lst[[ loop_counter ]] <<- messages),
#           check      = expression( loop_counter < 100 ),
#           timeout_ms = 500
#         )
#
#       expect_true(
#         length(lst) == 100
#       )
#
#       expect_true(
#         {
#           all(
#             vapply(
#               X         = lst,
#               FUN       = function(x){"data.frame" %in% class(x)},
#               FUN.VALUE = TRUE
#             )
#           )
#         }
#       )
#
#     }
# )


#
#
#
# test_that(
#   desc = "Consumer use consume_loop in batches",
#   code =
#     {
#
#       skip_if_kafka_on_is_missing()
#
#       cns <- kafka_consumer()
#       cns$start()
#       cns$topics_subscribe("test500000")
#
#
#       lst <- vector(mode = "list", length = 100)
#       cns_lp <-
#         cns$consume_loop(
#           expr      = expression(lst[[ loop_counter ]] <<- messages),
#           check     = expression( loop_counter < 100 )
#         )
#
#       expect_true(
#         length(lst) == 100
#       )
#
#       expect_true(
#         {
#           all(
#             vapply(
#               X         = lst,
#               FUN       = function(x){"data.frame" %in% class(x)},
#               FUN.VALUE = TRUE
#             )
#           )
#         }
#       )
#
#     }
# )
#
#
#
#
#
# test_that(
#   desc = "Consumer use consume_loop in batches with timout",
#   code =
#     {
#
#       skip_if_kafka_on_is_missing()
#
#       cns <- kafka_consumer()
#       cns$start()
#       cns$topics_subscribe("test500000")
#
#
#       lst <- vector(mode = "list", length = 100)
#       cns_lp <-
#         cns$consume_loop(
#           expr       = expression(lst[[ loop_counter ]] <<- messages),
#           check      = expression( loop_counter < 100 ),
#           timeout_ms = 500
#         )
#
#       expect_true(
#         length(lst) == 100
#       )
#
#       expect_true(
#         {
#           all(
#             vapply(
#               X         = lst,
#               FUN       = function(x){"data.frame" %in% class(x)},
#               FUN.VALUE = TRUE
#             )
#           )
#         }
#       )
#
#     }
# )
#

















