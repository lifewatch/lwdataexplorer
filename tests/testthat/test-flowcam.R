## FlowCam
# Get data FlowCam
flowcam_list <- getFlowcamData("2018-01-01", "2018-12-31", params = TRUE)
flowcam_df <- getFlowcamData("2018-01-01", "2018-12-31", params = FALSE)

# Test FlowCam
test_that("FlowCam", {
  #skip_on()
  expect_equal(class(flowcam_list), "list")
  expect_equal(class(flowcam_list$par), "list")
  expect_equal(class(flowcam_list$mdf), 'data.frame')
  expect_equal(class(flowcam_df), 'data.frame')
  expect_warning(
    getFlowcamData('9999-12-01', '9999-12-31')
  )
})
