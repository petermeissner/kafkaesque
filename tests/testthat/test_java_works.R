
context("2 Java")

test_that(
  "Classes are acessible",
  {
        tmp <- rJava::.jnew("kafkaesque.App")
        tmp$test_method()
        rm(tmp)
        expect_true(TRUE)
  }
)

test_that(
  "Classes Kafka_props is acessible",
  {
    tmp <- rJava::.jnew("kafkaesque.Kafka_consumer_props")
    prop <- tmp$props()
    expect_true(
      length(jsonlite::fromJSON(tmp$to_json_pretty())) > 1
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
    expect_true(TRUE)
  }
)

test_that(
  "Classes Kafka_consumer is acessible",
  {
    tmp <- rJava::.jnew("kafkaesque.Kafka_producer")
    tmp$props
    expect_true(TRUE)
  }
)


test_that(
  "Classes Kafka_admin is acessible",
  {
    tmp <- rJava::.jnew("kafkaesque.Kafka_admin")
    tmp$props
    expect_true(TRUE)
  }
)



