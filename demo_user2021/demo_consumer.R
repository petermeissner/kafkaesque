library(kafkaesque)

consumer <- kafka_consumer()
consumer$start()
consumer$topics_list()
consumer$topics_subscribe("test")

consumer$consume_next()
consumer$consume_next()
consumer$consume_next()
consumer$consume_next()

