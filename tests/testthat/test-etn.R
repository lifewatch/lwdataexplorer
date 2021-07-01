## ETN
etn_action='Time bins'
etn_by="1 week"
etn_networks="All"
etn_projects="All"

# Get data ETN
etn_list <- getEtnData("2020-04-19", "2020-04-21", etn_action, etn_by, etn_networks, etn_projects, params = TRUE)
etn_df <- getEtnData("2020-04-19", "2020-04-21", etn_action, etn_by, etn_networks, etn_projects, params = FALSE)

# Test ETN
test_that("ETN", {
  #skip_on()
  expect_equal(class(etn_list), "list")
  expect_equal(class(etn_list$par), "list")
  expect_equal(class(etn_list$mdf), 'data.frame')
  expect_equal(class(etn_df), 'data.frame')
  expect_warning(
    getEtnData('9999-12-01', '9999-12-31', etn_action, etn_by, etn_networks, etn_projects)
  )
})