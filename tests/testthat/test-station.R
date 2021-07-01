## Station data
station_stations <- c("all")
station_categories <- c("all")

# Get data Station
station_list <- getStationData("2019-07-22", "2019-07-23", station_stations, station_categories, params = TRUE)
station_df <- getStationData("2019-07-22", "2019-07-23", station_stations, station_categories, params = FALSE)

# Test Station
test_that("Station", {
  #skip_on()
  expect_equal(class(station_list), "list")
  expect_equal(class(station_list$par), "list")
  expect_equal(class(station_list$mdf), 'data.frame')
  expect_equal(class(station_df), 'data.frame')
  expect_warning(
    getStationData('9999-12-01', '9999-12-31', station_stations, station_categories)
  )
})