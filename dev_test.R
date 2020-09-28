library("kafkaesque")
consumer <- kafka_consumer()

res <- consumer$java_consumer$testreturn()

