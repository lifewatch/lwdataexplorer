## Bats
bats_by <- "1 day"

# Get data bats
bats_list <- getBatsData('2019-08-01', '2019-09-01', bats_by, params = TRUE)
bats_df <- getBatsData('2019-08-01', '2019-09-01', bats_by, params = FALSE)

# Test bats
test_that("Bats", {
  #skip_on()
  expect_equal(class(bats_list), "list")
  expect_equal(class(bats_list$par), "list")
  expect_equal(class(bats_list$mdf), 'data.frame')
  expect_equal(class(bats_df), 'data.frame')
  expect_warning(
    getBatsData('9999-12-01', '9999-12-31', bats_by, params = FALSE)
  )
})
