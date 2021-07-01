## Underway
underway_by <- "60 min"

# Get data Underway
underway_list <- getUnderwayData("2021-03-15", "2021-04-13", underway_by, params = TRUE)
underway_df <- getUnderwayData("2021-03-15", "2021-04-13", underway_by, params = FALSE)

# Test Underway
test_that("Underway", {
  #skip_on()
  expect_equal(class(underway_list), "list")
  expect_equal(class(underway_list$par), "list")
  expect_equal(class(underway_list$mdf), 'data.frame')
  expect_equal(class(underway_df), 'data.frame')
  expect_warning(
    getUnderwayData('9999-12-01', '9999-12-31', underway_by)
  )
})