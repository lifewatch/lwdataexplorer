## Station data
station_stations <- c("all")
station_categories <- c("all")

# Get data Station
station_list <- getStationData("2019-07-22", "2019-07-23", station_stations, station_categories, params = TRUE)
station_df <- getStationData("2019-07-22", "2019-07-23", station_stations, station_categories, params = FALSE)

# Test Station
test_that("Station", {
  #skip_on()
  expect_true(is.list(station_list))
  expect_true(is.list(station_list$par))
  expect_true(is.data.frame(station_list$mdf))
  expect_true(is.data.frame(station_df))
  expect_warning(
    getStationData('9999-12-01', '9999-12-31', station_stations, station_categories)
  )
})
