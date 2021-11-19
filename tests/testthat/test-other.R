test_that("lw_check_lwdataserver returns boolean", {
  is_lw_server <- lw_check_lwdataserver()
  expect_equal(class(is_lw_server), "logical")
})

test_that("lw_check_lwdataserver handles different scenarios", {
  expect_false(suppressWarnings(lw_check_lwdataserver(force_opencpu = TRUE)))

  # Check in case server is installed
  is_server_installed <- "lwdataserver" %in% utils::installed.packages()[, 1]

  if(is_server_installed){
    # Expect a warning if server is installed but using opencpu is forced
    expect_warning(lw_check_lwdataserver(force_opencpu = TRUE))

    # Expect true by default if server is installed
    expect_true(lw_check_lwdataserver())

  }else if(!is_server_installed){
    expect_false(lw_check_lwdataserver())
  }

})
