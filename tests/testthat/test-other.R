test_that("lw_rstudio_check_connection returns boolean", {
  is_lw_server <- lw_rstudio_check_connection()
  expect_equal(class(is_lw_server), "logical")
})
