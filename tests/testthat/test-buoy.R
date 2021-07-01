## Buoy
buoy_stations <- c("Buoy at C-Power","Spuikom Sluice","Buoy in Spuikom")

# Get data Buoy

buoy_list <- getBuoyData("2020-04-19", "2020-04-21", buoy_stations, params = TRUE)
buoy_df <- getBuoyData("2020-04-19", "2020-04-21", buoy_stations, params = FALSE)

# Test Buoy
test_that("Buoy", {
  #skip_on()
  expect_equal(class(buoy_list), "list")
  expect_equal(class(buoy_list$par), "list")
  expect_equal(class(buoy_list$mdf), 'data.frame')
  expect_equal(class(buoy_df), 'data.frame')
  expect_warning(
    getBuoyData('9999-12-01', '9999-12-31', buoy_stations)
  )
})