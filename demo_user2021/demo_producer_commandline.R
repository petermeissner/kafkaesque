library(kafkaesque)
library(fortunes)

producer <- kafka_producer()
producer$start()

i <- 0
while ( TRUE ) {
  Sys.sleep(0.001)
  i <- i + 1
  producer$send(
    topic = "user2021",
    msg   = paste(i, "-", paste(fortunes::fortune(), collapse = "\n"))
  )
}

