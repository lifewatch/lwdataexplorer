etn <- lwdata('listETNprojects')
mvb <- lwdata('listMVBstations')
uva <- lwdata('listUVAtags')

test_that("List methods return a data.frame", {
  expect_equal(class(etn), "data.frame")
  expect_equal(class(mvb), "data.frame")
  expect_equal(class(uva), "data.frame")
})
