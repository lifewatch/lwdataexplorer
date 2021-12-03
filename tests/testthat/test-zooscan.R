## ZooScan

# Get data ZooScan
zoo_list <- getZooscanData("2013-03-25", "2013-03-27", params = TRUE)
zoo_df <- getZooscanData("2013-03-25", "2013-03-27", params = FALSE)

# Test ZooScan
test_that("ZooScan", {
  #skip_on()
  expect_true(is.list(zoo_list))
  expect_true(is.list(zoo_list$par))
  expect_true(is.data.frame(zoo_list$mdf))
  expect_true(is.data.frame(zoo_df))
  expect_warning(
    getZooscanData('9999-12-01', '9999-12-31')
  )
})

