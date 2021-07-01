library(testthat)
library(lwdataexplorer)

skip_on <- function(){
  testthat::skip_on_cran()
  testthat::skip_on_ci()
}

test_check("lwdataexplorer")
