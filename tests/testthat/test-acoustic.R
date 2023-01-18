test_that("Acoustic", {
  skip_if_offline()

  # Get data Acoustic
  acoustic_list <- getAcousticData("2021-03-26T10:35:00.00Z", "2021-03-26T10:45:00.00Z", minband = 9, maxband = 11, by = "1 min", params = TRUE)
  acoustic_df <- getAcousticData("2021-03-26T10:35:00.00Z", "2021-03-26T10:45:00.00Z", minband = 10, maxband = 10, by = "1 min", force_opencpu = TRUE)

  # Check output
  expect_type(acoustic_list, "list")
  expect_type(acoustic_list$par, "list")
  expect_s3_class(acoustic_list$mdf, "data.frame")
  expect_s3_class(acoustic_df, "data.frame")

  # Test failure
  .f <- function() getAcousticData("2021-03-26", "2021-03-27", minband = 9, maxband = 11, by = "1 min", params = TRUE)
  expect_error(.f())

  .f <- function() getAcousticData("2021-03-26 10:35:00.00", "2021-03-26 10:45:00.00", minband = 9, maxband = 11, by = "1 min", params = TRUE)
  expect_error(.f())


})
