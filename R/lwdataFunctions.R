########################
#### Base functions ####
########################

# Ease of use function to use w/o shiny app
#' Function to retrieve data from the LifeWatch project
#'
#'Large wrapper function that retrieves the LifeWatch data. Use datatype specific functions for clearer use.
#' @return The sum of \code{x} and \code{y}
#' @param datatype Type of data to request
#' @param from Starting date for the query
#' @param to Stopping date for the query
#' @param stations (Buoy, MVB, Station) list of stations to be included in the query
#' @param binSize (Bats, ETN, CPOD, MVB, UvaBird, Underway) Sample period.
#' @param calc (MVB) Calculation to perform given time grouping, one of ('avg', 'max', 'min', 'none')
#' @param UrlPar .
#' @param code .
#' @param posres .
#' @param logged (CPOD, MVB, ETN, UvaBird) Request data under moratory if you have an account
#' @param projectlist .
#' @param tagprojectlist .
#' @param loggedInUserPostgresUsername (CPOD, MVB, ETN, UvaBird) Postgres username
#' @param loggedInUserPostgresPwd (CPOD, MVB, ETN, UvaBird) Postgres password
#' @param phylasp .
#' @param taxranks .
#' @param qualities .
#' @param processing (CPOD) One of ('Validated','Raw')
#' @param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#' @examples
#' lwdata()
#' lwdata('listETNprojects')
#' lwdata('zooscan-data')
#' lwdata('flowcam-data')
#' lwdata('MVB')
#' lwdata('station-data')
#' lwdata('cpod-data')
#' lwdata('etn-data')
#' @export
lwdata<- function(
  datatype='Buoy data',
  from=as.character(Sys.Date()-90),
  to=as.character(Sys.Date()),
  stations=c("Buoy at C-Power"),
  binSize="60 min",
  calc='Time bins',
  UrlPar=NULL,
  code=NULL,
  posres=2,
  logged=FALSE,
  projectlist=NULL,
  tagprojectlist=NULL,
  loggedInUserPostgresUsername = NULL,
  loggedInUserPostgresPwd = NULL,
  phylasp='#2#51#',
  taxranks=c(Species=220),
  qualities=c("Hi"),
  processing='Validated',
  params = FALSE) {

  input=list()
  USER = list()

  input$type=datatype
  input$daterange=c(from,to)
  input$stationlist=stations
  input$binSize=binSize
  input$calculate=calc
  input$UrlPar=UrlPar
  input$tags=code
  input$posres=posres

  input$projects=projectlist
  input$tagProjects=tagprojectlist
  input$phyla=phylasp
  input$taxranks=taxranks
  input$quality=qualities
  input$processing=processing

  input$getPar = params

  USER$postgresUserName=loggedInUserPostgresUsername
  USER$postgresPwd=loggedInUserPostgresPwd

  # Function call
  if(lw_check_lwdataserver()){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }
  return(lw_output_qc(input, out))
}

# Function to use in LWDE
#'For use in the LifeWatch Rshiny data-explorer (LWDE). Reads input and USER arguments
#'@param type Datatype as defined in LWDE
#'@param input LWDE input element, as a list. Can be obtained by using shiny::reactiveValuesToList()
#'@param USER LWDE USER element, as a list. Can be obtained by using shiny::reactiveValuesToList()
#'@param ... Params to be passed to lw_check_lwdataserver()
#'@return Returns dataframe of the requested datatype
#'@examples
#'lwdata2("listETNprojects")
#'input=c()
#'input$daterange = c(Sys.Date()-365*2, Sys.Date())
#'lwdata2("ZooScan data", input)
#'lwdata2("flow", input)
#'@export
lwdata2 = function(type,
                   input=NULL,
                   USER=NULL, ...){
  # Use when input and USER vector
  input$type = type
  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }
  return(out)
}

#####################################
#### datatype specific functions ####
#####################################
#### LIST DATATYPE SPECIFIC PARAMETER FUNCTIONS ####

#' Retrieve an overview of the ETN data.
#'
#' Retrieves the name of network/animals?
#' To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'@param usr Username to connect to ETN database
#'@param pwd Password to connect to ETN database
#'@return Dataframe with name and type of networks.
#'@examples
#'listEtnProjects()
#'@export
listEtnProjects <- function(usr = NULL,
                            pwd = NULL){
  USER=c()
  USER$username = usr
  USER$password = pwd
  return(lwdata2('listETNprojects'
                 , USER=USER
  ))
}

#' List available stations for Meetnet Vlaamse Banken (MVB)
#'
#' To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'@param usr Username to connect to ETN database
#'@param pwd Password to connect to ETN database
#'@export
listMvbStations <- function(usr = NULL,
                            pwd = NULL){
  USER=c()
  USER$username = usr
  USER$password = pwd
  return(lwdata2('listMVBstations', USER=USER))
}

#'List available  UVA bird tags
#'
#'To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'@param usr Username to connect to ETN database
#'@param pwd Password to connect to ETN database
#'@export
listUvaTags <- function(usr = NULL,
                        pwd = NULL){
  USER=c()
  USER$username = usr
  USER$password = pwd
  return(lwdata2('listUVAtags', USER=USER))
}

#### GET DATATYPE SPECIFIC DATA FUNCTIONS ####

#'Retrieve zooscan-data from the LifeWatch project
#'
#'Retrieves the aggregated zooscan data from the LifeWatch project.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the aggregated zooscan-data within the specified daterange.
#'@examples
#'getZooscanData("2011-01-01", "2021-04-14") # Only data
#'getZooscanData("2011-01-01", "2021-04-14", TRUE) # Data + query parameters
#' @export
getZooscanData <- function(startdate, stopdate, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "ZooScan data"
  input$getPar = params

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve flowcam-data from the LifeWatch project
#'
#'Retrieves the aggregated flowcam data from the LifeWatch project.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the aggregated flowcam-data within the specified daterange.
#'@examples
#'getFlowcamData("2020-04-19", "2020-04-21") # Only data
#'getFlowcamData("2020-04-19", "2020-04-21", TRUE) # Data + query parameters
#' @export
getFlowcamData <- function(startdate, stopdate, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "FlowCam data"
  # print(input)
  input$getPar = params

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve batcorder-data from the LifeWatch project
#'
#'Retrieves the aggregated batcorder data from the LifeWatch project.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param by Sample period, one of "1 min", "60 min" or "1 day"
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the aggregated batcorder-data within the specified daterange.
#'@examples
#'getBatsData("2014-08-01", "2014-09-01", "1 min")
#'getBatsData("2014-08-01", "2014-09-01", "60 min", TRUE)
#'getBatsData("2014-08-01", "2014-09-01", "1 day", TRUE)
#'@export
getBatsData <- function(startdate, stopdate, by, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$binSize=by
  input$type = "Bats data"
  input$getPar = params
  # print(input)

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve Buoy-data from the LifeWatch project
#'
#'Retrieves the aggregated buoy data from the LifeWatch project.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param stations list of stations to be included in the query, currently list c("Buoy at C-Power","Spuikom Sluice","Buoy in Spuikom", "Ostend Research Tower"). Use \code{stations = "All"} to get all stations .
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the buoy-data within the specified daterange and location.
#'@examples
#'getBuoyData("2021-03-19", "2021-04-21", "All")
#'getBuoyData("2021-03-19", "2021-04-21", "Buoy at C-Power", TRUE)
#'getBuoyData("2021-03-19", "2021-04-21", c("Spuikom Sluice", "Buoy in Spuikom",
#'"Ostend Research Tower"), TRUE)
#'@export
getBuoyData <- function(startdate, stopdate, stations,
                        params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$stationlist=stations
  input$type = "Buoy data"
  input$getPar = params

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve ETN-data from the LifeWatch project
#'
#'Retrieves the European Tracking Network (ETN) data from the LifeWatch project.
#' Need valid authentication to access the entire data. To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param action One of ('Time bins','Residencies','Active network','Detections')
#'@param by Sample period, one of ("1 day", "1 week", "60 min","10 min", "1 min")
#'@param networks List of networks to be included in the query. See \code{\link{listEtnProjects}}.
#'@param projects List of projects to be included in the query. See \code{\link{listEtnProjects}}.
#'@param usr Username to connect to ETN database
#'@param pwd Password to connect to ETN database
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the specified ETN data.
#'@examples
#'getEtnData("2020-04-19", "2020-04-21", action = "Time bins", by = "1 day",
#'networks = "All", projects = "All")
#'getEtnData("2016-01-01", "2017-12-31", action = "All", by = "1 week",
#'networks = "Azorean acoustic receiver network", projects = "Lifewatch", params = TRUE)
#'@export
getEtnData <- function(startdate, stopdate, action, by, networks, projects,
                       usr = NULL, pwd = NULL, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "ETN data"
  input$getPar = params

  USER = list()
  input$binSize=by
  input$calculate=action

  input$projects=networks
  input$tagProjects=projects

  USER$username=usr
  USER$password=pwd

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = USER, client = TRUE))
  }else{
    out = basicPostJson(input = input, USER = USER)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve C-POD data from the LifeWatch project
#'
#' Retrieves the C-POD (Cetacean Acoustic Hydrophone Network) data from the LifeWatch project.
#' Need valid authentication to access the entire data.To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param processing One of ('Validated','Raw'). If "Validated", the quality parameter is ignored.
#'@param quality One or more of ("Hi","Mod", "Lo"). This parameter is ignored if processing = "Validated"
#'@param by Sample period, one of ("1 day", "1 week", "60 min","10 min", "1 min")
#'@param usr Username to connect to ETN database
#'@param pwd Password to connect to ETN database
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the specified C-POD data.
#'@examples
#'getCpodData("2020-04-19", "2020-04-21", processing = "Validated", by = "1 week")
#'getCpodData("2020-04-19", "2020-04-21", processing = "Raw",
#'quality = c("Hi", "Lo"), by = "1 day", params = TRUE)
#'@export
getCpodData <- function(startdate, stopdate, processing, quality = c("Hi", "Mod", "Lo"), by,
                        usr = NULL, pwd = NULL, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "CPOD data"
  input$getPar = params

  USER = list()
  input$binSize=by
  input$processing=processing

  input$quality=quality

  USER$username=usr
  USER$password=pwd

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = USER, client = TRUE))
  }else{
    out = basicPostJson(input = input, USER = USER)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve MVB-data from the LifeWatch project
#'
#'Retrieves the Meetnet Vlaams Banken (MVB) data from the LifeWatch project. Without valid credentials you are only allowed to view the "Tide TAW" parameter for the last 30 days, grouped by day/hour.
#'To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'@param startdate Starting date for the query. Without a login, this is restricted to the last month
#'@param stopdate Stopping date for the query. Without a login, this is restricted to the last month
#'@param parameters One (or list) of the \code{$parameter} in \code{\link{listMvbStations}}.
#'@param stations List of stations to be included in the query. See \code{\link{listMvbStations}}. Use \code{stations="All"} or \code{stations=NULL} to get all stations.
#'@param by Time grouping for calculation, one of ('day','hour', '10min' ,'none')
#'@param calc Calculation to perform given time grouping, one of ('avg', 'max', 'min', 'none').
#'@param usr Username to connect to database
#'@param pwd Password to connect to database
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the specified MVB data.
#'@examples
#'getMvbData(Sys.Date() - 30, Sys.Date() + 1, parameters = 'Tide TAW',
#'stations = "Nieuwpoort", by = "day", calc = "avg")
#'getMvbData(Sys.Date() - 30, Sys.Date() + 1, parameters = 'Tide TAW',
#'stations = "Blankenberge", by = "hour", calc = "max", params = TRUE)
#'@export
getMvbData <- function(startdate, stopdate, parameters, stations = NULL, by, calc, # QCFlag=c(0,3),
                       usr = NULL, pwd = NULL, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "MVB data"
  input$getPar = params

  input$stations = stations
  input$calc = calc
  input$binSize = by
  # input$QCFlag = QCFlag
  input$parameters = parameters

  USER = list()
  USER$username=usr
  USER$password=pwd

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = USER, client = TRUE))
  }else{
    out = basicPostJson(input = input, USER = USER)
  }

  return(lw_output_qc(input, out))
}

#'Retrieve UVA-bird-data from the LifeWatch project
#'
#'Retrieves the University of Amsterdam (UvA) Bird Tracking System data from the LifeWatch project.
#' Need valid authentication to access the entire data. To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
#'Without login you can only access data collected at least two years ago.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param tagcodes List of tag numbers from \code{$tagnr} in \code{\link{listUvaTags}}. Can also use "All HG" "All LBB" or "All MH" (MH only when logged in).
#'@param by Time grouping for aggregation, one of ("1 day","60 min","10 min","1 min","1 week")
#'@param usr Username to connect to database
#'@param pwd Password to connect to database
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the specified bird tracking data.
#'@examples
#'getUvaBirdData("2013-06-10", "2013-06-14", tagcodes = c("719","6013","610"), by = "1 day")
#'getUvaBirdData("2013-06-10", "2013-06-14", tagcodes = "All HG", by = "1 week", params = TRUE)
#'@export
getUvaBirdData <- function(startdate, stopdate, tagcodes, # p=2,
                           by, usr = NULL, pwd = NULL, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "UVA bird data"
  input$tags = as.character(tagcodes)
  # input$posres = 2
  input$binSize = by
  input$getPar = params

  USER = list()
  USER$username = usr
  USER$password = pwd

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = USER, client = TRUE))
  }else{
    out = basicPostJson(input = input, USER = USER)
  }

  return(lw_output_qc(input, out))

}


#'Retrieve Station-data from the LifeWatch project
#'
#'Retrieves the station data from the LifeWatch project.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param stations list of stations to be included in the query. Use \code{stations="all"} to get all stations.
#'@param categories List of categories to return in query, one of  ("SPM", "CTD", "Nutrients", "Secchi", "Pigments"). Use \code{categories="All"} to get all categories
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@return Dataframe with the Station-data.
#'@examples
#'getStationData("2019-07-22", "2019-07-23", stations = "all", categories = "all")
#'getStationData("2019-07-22", "2019-07-23", stations = c(120, 215),
#'categories = c("Nutrients", "Secchi"), params = TRUE)
#'@export
getStationData <- function(startdate, stopdate, stations = "all", categories = "all", params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "Station data"
  input$stationlist = stations
  input$categories=categories
  input$getPar = params

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  return(lw_output_qc(input, out))
}


#'Retrieve Underway-data from the LifeWatch project
#'
#'Retrieves the data collected by the MIDAS underway continuous sampling system on the RV Zeeleeuw and RV Simon Stevin as part of the LifeWatch project.
#'@param startdate Starting date for the query
#'@param stopdate Stopping date for the query
#'@param by Time grouping for data aggregation, one of ("1 day","60 min","10 min","1 min")
#'@return Dataframe with the specified data.
#'@param params If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.
#'@param ... Params to be passed to lw_check_lwdataserver().
#'@examples
#'getUnderwayData("2021-03-15", "2021-04-13", "1 day")
#'getUnderwayData("2021-03-15", "2021-04-13", "60 min", params = TRUE)
#'@export
getUnderwayData <- function(startdate, stopdate, by, params = FALSE, ...){
  input=list()
  input$daterange = c(as.character(as.Date(startdate)), as.character(as.Date(stopdate)))
  input$type = "Underway data"
  input$binSize = by
  input$getPar = params

  if(lw_check_lwdataserver(...)){
    utils::capture.output(out <- lwdataserver::getLWdata(input, USER = NULL, client = TRUE))
  }else{
    out = basicPostJson(input = input)
  }

  tab = lw_output_qc(input, out)
  return(tab)
}



##########################
#### HELPER FUNCTIONS ####
##########################
# Function used internally
basicPostJson = function(input=NULL,
                         USER=NULL){

  # Get BASE path from environment
  BASE_PATH = Sys.getenv("BASE_PATH")
  if (BASE_PATH==""){
    BASE_PATH="https://opencpu.lifewatch.be"
  }
  ocpu.url = file.path(file.path(BASE_PATH, "getLWdata/"), "json")

  mybody = list(
    'USER'=USER,
    'input'=input,
    'client'=TRUE
    )

  postreq = httr::content(
    httr::POST(url= ocpu.url,
               body = mybody,
               encode = 'json'),
    as="text")
  # if error:
  some.error=TRUE
  try({
    out = jsonlite::fromJSON(postreq)
    some.error=FALSE
  })

  if (some.error){
    out=cat(postreq)
  }
  return(out)

}


# Checks the output of the request to opencpu server and gives understandable feedback
lw_output_qc = function(input, out){

  # Assertions
  stopifnot(is.list(input))
  stopifnot(is.list(out) | is.character(out))

  # par and mdf splitted

  # If out is a string, it is an error. Pass to mdf and down
  if(is.character(out)){
    mdf <- out
  }else{
    mdf <- out$mdf
    par <- out$par
  }


  ## START QC

  # Check data type, different logic if list

  if(input$type %in% c('listETNprojects', 'listMVBstations', 'listUVAtags')){

    # If mdf is a character string
    if(is.character(mdf)){
      mdf <- lw_mdf_is_string(mdf)
      return(mdf)
    }

    return(out)
  }


  # If mdf is a tibble, turn into a base data frame
  if(tibble::is_tibble(mdf)){
    mdf <- as.data.frame(mdf, stringAsFactors = FALSE)
  }

  # If mdf is a data frame, check if it is empty and return a warning
  # If mdf is not empty, print log messages and return successfully
  if(is.data.frame(mdf)){

    lw_compare_parameters(input, par)

    if(nrow(mdf) == 0){
      lw_warning_empty()
    }


    # END
    # Check if parameters were requested or not
    if(isTRUE(input$getPar)){
      out$par$getPar <- NULL
      return(out)
    }else{
      return(mdf)
    }

  }

  # If mdf is list and empty, return a warning
  if(is.list(mdf)){

    if(length(mdf) == 0){
      return(lw_warning_empty())
    }else{stop()}

  }

  # If mdf is a character string
  if(is.character(mdf)){
    lw_mdf_is_string(mdf, input, par)
    return(NULL)
  }
  ## END QC

}


# What to do if output is a string
lw_mdf_is_string <- function(mdf, input = NULL, par = NULL){

  stopifnot(length(mdf) == 1)

  # Check if there is an error message
  if(grepl("error", mdf, ignore.case = TRUE)){
    message(mdf)
    warning("Something unexpected happened. Check the server logs.")
    return(NULL)

  # Check if the server returns a no data string
  }else if(grepl("data", mdf, ignore.case = TRUE) |
           grepl("null", mdf, ignore.case = TRUE) |
           grepl("results", mdf, ignore.case = TRUE)
           ){
    lw_warning_empty()
    lw_compare_parameters(input, par)
    return(NULL)

  # Any other case, raise an error
  }else{
    stop(mdf)
  }

}


# What to do in case of an empty response
lw_warning_empty <- function(){
  warning("No data returned")
  return(NULL)
}


# Compares two sets of parameters and raises a warning if they are different
lw_compare_parameters <- function(par_user, par_server){

  stopifnot(is.list(par_user))
  stopifnot(is.list(par_server))

  if(length(setdiff(par_user, par_server)) != 0){

    lw_print_parameters(par_user, "- Your query:")
    lw_print_parameters(par_server, "- Server query:")

    warning("The query applied on the server differ from the parameters you used.
Hint: You may need an account to fully access the data under moratorium.
Hint: Request access at: https://rshiny.lifewatch.be/account?p=register")

    # Print parameters if there're no issues
  }else{
    lw_print_parameters(par_server)
  }

}


# Prints parameters in the console
lw_print_parameters <- function(par, messg = "- Query parameters: "){
  # remove getPar
  par <- par[names(par) != "getPar"]

  # Print
  message(messg)

  for (i in 1:length(par)){
    name <- names(par)[i]
    message(paste0("   - ", name, ": ", par[i]))
  }

  # End
}


# Checks if the user has access to lwdataserver
lw_check_lwdataserver <- function(force_opencpu = FALSE){
  # Checks if lwdataserver is installed
  suppressWarnings(use_lwdataserver <- isTRUE(requireNamespace("lwdataserver", quietly = TRUE)))

  if(!use_lwdataserver | force_opencpu){
    message("- Query mode: Post request to OpenCPU server")

    if(use_lwdataserver & force_opencpu){
      use_lwdataserver <- FALSE
      warning("Data accessed through OpenCPU server but a direct connection to the database is available. Consider setting force_opencpu = FALSE to improve performance.")
    }

  }else if(use_lwdataserver & !force_opencpu){
    message("- Query mode: Database connection")
  }

  return(use_lwdataserver)
}
