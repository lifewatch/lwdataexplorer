## CPOD
cpod_processing <- 'Validated'
cpod_quality <- c("Hi", "Mod")
cpod_by="1 week"

# Get data CPOD
cpod_list <- getCpodData("2020-04-19", "2020-04-21", cpod_processing, cpod_quality, cpod_by, params = TRUE)
cpod_df <- getCpodData("2020-04-19", "2020-04-21", cpod_processing, cpod_quality, cpod_by, params = FALSE)

# Test CPOD
test_that("CPOD", {
  #skip_on()
  expect_equal(class(cpod_list), "list")
  expect_equal(class(cpod_list$par), "list")
  expect_equal(class(cpod_list$mdf), 'data.frame')
  expect_equal(class(cpod_df), 'data.frame')
  expect_warning(
    getCpodData('9999-12-01', '9999-12-31', cpod_processing, cpod_quality, cpod_by)
  )
})