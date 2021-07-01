## ZooScan

# Get data ZooScan
zoo_list <- getZooscanData("2013-03-25", "2013-03-27", params = TRUE)
zoo_df <- getZooscanData("2013-03-25", "2013-03-27", params = FALSE)

# Test ZooScan
test_that("ZooScan", {
  #skip_on()
  expect_equal(class(zoo_list), "list")
  expect_equal(class(zoo_list$par), "list")
  expect_equal(class(zoo_list$mdf), 'data.frame')
  expect_equal(class(zoo_df), 'data.frame')
  expect_warning(
    getZooscanData('9999-12-01', '9999-12-31')
  )
})
