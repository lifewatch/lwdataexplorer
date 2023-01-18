## MVB
mvb_parameters <- c("Tide (cmTAW)")
mvb_stations <- NULL
mvb_by <- "day"
mvb_calc <- "avg"

# QCFlag=c(0,3)

mvb_list <- getMvbData(Sys.Date() - 30, Sys.Date() + 1, mvb_parameters, mvb_stations, mvb_by, mvb_calc, params = TRUE)
mvb_df <- getMvbData(Sys.Date() - 30, Sys.Date() + 1, mvb_parameters, mvb_stations, mvb_by, mvb_calc, params = FALSE)

# Test ETN
test_that("Buoy", {
  #skip_on()
  expect_equal(class(mvb_list), "list")
  expect_equal(class(mvb_list$par), "list")
  expect_equal(class(mvb_list$mdf), 'data.frame')
  expect_equal(class(mvb_df), 'data.frame')
  expect_warning(
    getMvbData(Sys.Date() + 365, Sys.Date() + 365*2, mvb_parameters, mvb_stations, mvb_by, mvb_calc)
  )
})
