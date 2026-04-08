## CPOD
cpod_quality <- c("Hi", "Mod")

# Get data CPOD
cpod_list <- getCpodData("2020-04-19", "2020-04-21", quality = cpod_quality, params = TRUE)
cpod_df   <- getCpodData("2020-04-19", "2020-04-21", quality = cpod_quality, params = FALSE)

# Test CPOD
test_that("CPOD", {
  #skip_on()
  expect_equal(class(cpod_list), "list")
  expect_equal(class(cpod_list$par), "list")
  expect_equal(class(cpod_list$mdf), 'data.frame')
  expect_equal(class(cpod_df), 'data.frame')
  expect_warning(
    getCpodData('9999-12-01', '9999-12-31', quality = cpod_quality)
  )
})

test_that("getCpodData returns list with correct names when params = TRUE", {
  data <- getCpodData("2020-04-20", "2020-04-21", quality = "Hi", params = TRUE)
  expect_equal(names(data), c("mdf", "par"))
  expect_equal(unique(data$mdf$quality), 3)
})

test_that("getCpodData filters species and quality correctly", {
  data <- getCpodData("2020-04-20", "2020-04-21", species = c("Dolphins", "NBHF"), quality = c("Mod"))
  expect_setequal(unique(data$species), c("NBHF", "Dolphins"))
  expect_equal(unique(data$quality), 2)
})

test_that("getCpodData filters single species correctly", {
  data <- getCpodData("2020-04-20", "2020-04-21", species = "Dolphins")
  expect_equal(unique(data$species), "Dolphins")
  expect_equal(unique(data$quality), 3)
})

test_that("getCpodData applies projectcode", {
  expect_warning(getCpodData("2020-04-20", "2020-04-21", projectcode = "nonexistent"), "No data returned")
})

test_that("getCpodData validate parameters", {
  expect_warning(getCpodData("2020-04-20", "2020-04-21", projectcode = ";notallowed"), "Something unexpected happened. Check the server logs.") #TODO: better message
})

test_that("getCpodData with multiple quality filters returns correct quality codes", {
  data <- getCpodData("2020-04-20", "2020-04-21", quality = c("Hi", "Mod"))
  expect_setequal(unique(data$quality), c(2, 3)) #TODO: fails
})
