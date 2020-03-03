context("1 Trivial")

test_that(
  desc = "one plus one is two",
  code =
    {
      expect_equal(1 + 1, 2)
    }
)
