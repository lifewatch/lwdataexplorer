#' Retrieve Acoustic data from the LifeWatch project
#'
#' Retrieves the aggregated buoy data from the LifeWatch project.
#' @param startdate Starting date for the query in UTC. Must be a character date of the form "2020-02-26T10:35:00.00Z"
#' @param stopdate Stopping date for the query in UTC. Must be a character of the form "2020-02-26T11:35:00.00Z"
#' @param minband lower frequency band from which the sound value will be retrieved
#' @param maxband upper frequency band from which the sound value will be retrieved
#' @param by Sample period, one of "1 min", "1 hour" or "1 day"
#' @param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#' @param ... Params to be passed to lw_check_lwdataserver().
#' @return Dataframe with the buoy-data within the specified daterange and location.
#' @examples
#'getAcousticData("2021-03-26T10:35:00.00Z", "2021-03-26T10:45:00.00Z", minband = 9, maxband = 11, by = "1 min")
#'@export
getAcousticData <- function(startdate, stopdate, minband, maxband, by,
                        params = FALSE, ...){

  # Start placeholder
  input=list()
  input$type = "acoustic data"
  input$getPar = params
  input$daterange = c()

  # Assertions
  checkmate::assert_character(by, len = 1)
  checkmate::assert_choice(by, c("1 min", "1 hour", "1 day"))
  input$binSize = by

  # Assert startdate
  checkmate::assert_character(startdate, len = 1, min.chars = 1)
  tryCatch(lubridate::ymd_hms(startdate),
           warning = function(x) {stop('`startdate` cannot be coerced into a date of class POSIXct')})

  startdate_as_char = unlist(strsplit(startdate, ""))
  has_not_T_and_Z <- !all(c(isTRUE(startdate_as_char[11] == "T"), isTRUE(startdate_as_char[length(startdate_as_char)] == "Z")))
  if(has_not_T_and_Z){ stop("`startdate` must be a character date of the format 'YYYY-MM-DDTHH:MM:SS.00Z' \n Did you forget to include the 'T' or the 'Z'?") }

  input$daterange[1] = startdate
  stardate <- lubridate::ymd_hms(startdate)


  # Assert stopdate
  checkmate::assert_character(stopdate, len = 1, min.chars = 1)
  tryCatch(lubridate::ymd_hms(stopdate),
           warning = function(x) {stop('`stopdate` cannot be coerced into a date of class POSIXct')})

  stopdate_as_char = unlist(strsplit(stopdate, ""))
  has_not_T_and_Z <- !all(c(isTRUE(stopdate_as_char[11] == "T"), isTRUE(stopdate_as_char[length(startdate_as_char)] == "Z")))
  if(has_not_T_and_Z){ stop("`stopdate` must be a character date of the format 'YYYY-MM-DDTHH:MM:SS.00Z' \n Did you forget to include the 'T' or the 'Z'?") }

  input$daterange[2] = stopdate
  stopdate <- lubridate::ymd_hms(stopdate)

  # Assert stopdate is lower than startdate
  checkmate::assert_true(startdate <= stopdate)


  # Assert bands
  checkmate::assert_integerish(minband, len = 1, lower = 1, upper = 999999999, coerce = TRUE)
  checkmate::assert_integerish(maxband, len = 1, lower = 1, upper = 999999999, coerce = TRUE)
  if(minband > maxband) stop(glue::glue("`maxband` cannot be lower than `minband` \n - minband: {minband} \n - maxband: {maxband}"))

  input$bands = c(minband, maxband)


  # Perform

  if(lw_check_lwdataserver(..., datatype = input$type)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}

