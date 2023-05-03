## CTD
ctd_by <- "Per meter"

# Get data bats
ctd_list <- getCTDData("2023-01-15", "2023-02-15", stations = c("120", "W09"), by = ctd_by, params = TRUE)
ctd_df <- getCTDData("2023-01-15", "2023-02-15", stations = c("120", "W09"), by = ctd_by, params = FALSE)

# Test CTD
test_that("CTD", {
  #skip_on()
  expect_equal(class(ctd_list), "list")
  expect_equal(class(ctd_list$par), "list")
  expect_equal(class(ctd_list$mdf), 'data.frame')
  expect_equal(class(ctd_df), 'data.frame')
  expect_warning(
    getCTDData('9999-12-01', '9999-12-31', stations = c("120", "W09"), by = ctd_by, params = FALSE)
  )
})
