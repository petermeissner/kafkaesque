
context("2 Java")

test_that(
  "Classes are acessible",
  {
    library()
        tmp <- rJava::.jnew("kafkaesque.App")
        tmp$test_method()
        rm(tmp)
  }
)

test_that(
  "Classes Kafka_props is acessible",
  {
    tmp <- rJava::.jnew("kafkaesque.Kafka_consumer_props")
    prop <- tmp$props()
    expect_true(
      length(grep(pattern = "\\{", tmp$to_json_pretty())) > 1
    )
    rm(tmp)
    rm(prop)
  }
)

test_that(
  "Classes Kafka_producer is acessible",
  {
    tmp <- rJava::.jnew("kafkaesque.Kafka_consumer")
    tmp$props
  }
)

test_that(
  "Classes Kafka_consumer is acessible",
  {
    tmp <- rJava::.jnew("kafkaesque.Kafka_producer")
    tmp$props
  }
)



