## CPOD
cpod_quality <- c("Hi", "Mod")

# Get data CPOD
cpod_list <- getCpodData("2020-04-19", "2020-04-21", quality = cpod_quality, params = TRUE)
cpod_df   <- getCpodData("2020-04-19", "2020-04-21", quality = cpod_quality, params = FALSE)

# Test CPOD
test_that("CPOD", {
  #skip_on()
  expect_equal(class(cpod_list), "list")
  expect_equal(class(cpod_list$par), "list")
  expect_equal(class(cpod_list$mdf), 'data.frame')
  expect_equal(class(cpod_df), 'data.frame')
  expect_warning(
    getCpodData('9999-12-01', '9999-12-31', quality = cpod_quality)
  )
})
