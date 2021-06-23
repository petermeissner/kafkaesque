options(scipen=9000)

library(kafkaesque)

consumer <- kafka_consumer()
consumer$start()
consumer$topics_list()
consumer$topics_subscribe("test500000")


i <- 0
v <- 0

res <-
  consumer$consume_loop(
    f =
      function(loop_env){
        cat("\r", i)
        i <<- i + 1
        v <<- v + sum(as.integer(loop_env$messages$value))
      },
    check =
      function(loop_env) {
        loop_env$meta$message_counter < 10 * 1000
      },
    batch = TRUE
  )

print(paste0("i = ", i, "; v = ", v))

res$meta$end_time - res$meta$start_time

