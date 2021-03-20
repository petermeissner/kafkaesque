context("gnrndmsg()")


test_that(
  desc = "Function works without errors",
  code =
    {

      tst <- gnrndmsg()
      expect_true(inherits(tst, "character"))

      tst <- gnrndmsg(n = 123)
      expect_true(length(tst) == 123)


    }
)






