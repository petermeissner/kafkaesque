options(scipen=9000)

library(kafkaesque)

consumer <- kafka_consumer()
consumer$start()
consumer$topics_list()
consumer$topics_subscribe("user2021")


res <-
  consumer$consume_loop(
    f =
      function(loop_env){
        cat(loop_env$messages$value, "\n")
      },
    check = function(loop_env){ TRUE }
  )
