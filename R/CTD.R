#' Retrieve CTD data from the LifeWatch project
#'
#' @param startdate Starting date for the query in UTC. Must be a character date of the form "YYYY-MM-DD".
#' @param stopdate Stopping date for the query in UTC. Must be a character date of the form "YYYY-MM-DD".
#' @param stations  List of stations to be included in the query. Use stations = "All" to get all stations. See stations list in details section.
#' @param by Aggregation criteria. One of c("Per meter", "Per cast")
#' @param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#' @param ... Reserved for internal use.
#'
#' @details
#'
#' List of stations:
#' c("120", "130", "230", "215", "330", "421", "435", "710", "700",
#' "780", "ZG02", "W09", "W08", "LW01", "W10", "LW02", "W07bis")
#'
#' @return Dataframe with the CTD data within the specified daterange and location.
#' @export
#'
#' @examples
#' getCTDData("2023-01-15", "2023-02-15", stations = c("130", "W07bis"), by = "Per meter")
#' getCTDData("2023-01-15", "2023-02-15", stations = c("130", "W07bis"), by = "Per meter", params = TRUE)
getCTDData <- function(startdate, stopdate, stations = "All", by,
                            params = FALSE, ...){

  # Start placeholder
  input=list()
  input$type = "ctd"
  input$getPar = params
  input$daterange = c()
  input$stationlist <- NULL
  input$all <- NULL

  # Assertions
  checkmate::assert_character(by, len = 1)
  checkmate::assert_choice(by, c("Per meter", "Per cast"))
  input$bintype = by

  # Assert startdate
  checkmate::assert_character(startdate, len = 1, min.chars = 1)
  input$daterange[1] = startdate
  startdate = as.Date(startdate)

  # Assert stopdate
  checkmate::assert_character(stopdate, len = 1, min.chars = 1)
  input$daterange[2] = stopdate
  stopdate = as.Date(stopdate)

  # Assert stopdate is lower than startdate
  checkmate::assert_true(startdate <= stopdate)

  # Assert stations
  checkmate::assert_character(stations, min.len = 1, unique = TRUE)
  all_stations <- c("120", "130", "230", "215", "330", "421", "435", "710", "700",
                    "780", "ZG02", "W09", "W08", "LW01", "W10", "LW02", "W07bis")

  if(any(stations == "All")){
    stations <- all_stations
  }else{
    not_valid_stations <- !all(stations %in% all_stations)
    if(not_valid_stations){
      stop(glue::glue("Assertion on `stations` failed: Must be element of set {paste0(all_stations, collapse = ', ')}, but is {paste0(stations, collapse = ', ')}"))
    }
  }
  input$stationlist <- stations

  # Perform
  if(lw_check_lwdataserver(..., datatype = input$type)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}
