## Uva Bird
uva_tagcodes <- c("719","6013","610")
uva_by <- "1 day"

# Get data Uva Bird
uva_list <- getUvaBirdData("2013-06-10", "2013-06-14", uva_tagcodes, uva_by, params = TRUE)
uva_df <- getUvaBirdData("2013-06-10", "2013-06-14", uva_tagcodes, uva_by, params = FALSE)

# Test Uva Bird
test_that("Uva_Bird", {
  #skip_on()
  expect_equal(class(uva_list), "list")
  expect_equal(class(uva_list$par), "list")
  expect_equal(class(uva_list$mdf), 'data.frame')
  expect_equal(class(uva_df), 'data.frame')
  expect_warning(
    getUvaBirdData('9999-12-01', '9999-12-31', uva_tagcodes, uva_by)
  )
})