test_that("lw_check_config works", {
  expect_true(lw_check_config(test = TRUE, test_config = "HOME"))
  expect_true(lw_check_config(test = TRUE, test_config = c("HOME", "R_HOME")))

  expect_false(suppressWarnings(lw_check_config(test = TRUE, test_config = "THISISNOTAVAR1234")))
  expect_false(suppressWarnings(lw_check_config(
    test = TRUE, test_config = c("HOME", "R_HOME", "THISISNOTAVAR1234", "THISISNOTAVAR5678")
  )))

  expect_warning(lw_check_config(test = TRUE, test_config = "THISISNOTAVAR1234"))
})

test_that("lw_check_lwdataserver returns boolean", {
  is_lw_server <- lw_check_lwdataserver(test = TRUE, test_config = "HOME")
  expect_equal(class(is_lw_server), "logical")
})

test_that("lw_check_lwdataserver handles different scenarios", {
  expect_false(suppressWarnings(lw_check_lwdataserver(force_opencpu = TRUE, test = TRUE, test_config = "HOME")))

  # Check in case server is installed
  is_server_installed <- "lwdataserver" %in% utils::installed.packages()[, 1]

  if(is_server_installed){

    # Expect true by default if server is installed
    expect_true(lw_check_lwdataserver(test = TRUE, test_config = "HOME"))

  }else if(!is_server_installed){
    expect_false(lw_check_lwdataserver(test = TRUE, test_config = "HOME"))
  }

})
