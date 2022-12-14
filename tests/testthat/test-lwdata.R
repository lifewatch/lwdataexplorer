etn <- lwdata2('listETNprojects')
mvb <- lwdata2('listMVBstations')
uva <- lwdata2('listUVAtags')

test_that("List methods return a data.frame", {
  expect_equal(class(etn), "data.frame")
  expect_equal(class(mvb), "data.frame")
  expect_equal(class(uva), "data.frame")
})
