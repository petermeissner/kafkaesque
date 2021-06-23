library(kafkaesque)


producer <- kafka_producer()
producer$start()

producer$send(topic = "user2021", msg = "Ducks are the new cats.")
producer$send(topic = "user2021", msg = "Ducks are the new cats.")
producer$send(topic = "user2021", msg = "In 2021 ducks are the new cats.")
producer$send(topic = "user2021", msg = "In 2021 ducks are the new cats.")
producer$send(topic = "user2021", msg = "Don't be smug, get a duck.")
