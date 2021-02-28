context("1 Trivial")


test_that(
  desc = "create consumer",
  code =
    {

      consumer <- kafka_consumer()

      # starting/connecting - + status
      consumer$start()

      expect_true({
        consumer$running()
      })

      expect_false({
        consumer$end()$running()
      })

      expect_true({
        consumer$start()$running()
      })
    }
)
