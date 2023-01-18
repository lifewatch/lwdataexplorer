##########################
#### HELPER FUNCTIONS ####
##########################
# Function used internally
basicPostJson = function(input=NULL,
                         USER=NULL){

  # Get BASE path from environment
  BASE_PATH = Sys.getenv("BASE_PATH")
  if (BASE_PATH==""){
    BASE_PATH="https://opencpu.lifewatch.be/library/lwdataserver/R/"
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
    warning("Something unexpected happened. Check the server logs.", call. = FALSE)
    return(NULL)

    # Check if the server returns a no data string
  }else if(grepl("data", mdf, ignore.case = TRUE) |
           grepl("null", mdf, ignore.case = TRUE) |
           grepl("results", mdf, ignore.case = TRUE)
  ){
    lw_warning_empty()
    lw_compare_parameters(input, par)
    return(invisible(NULL))

    # Any other case, raise an error
  }else{
    stop(mdf, call. = FALSE)
  }

}


# What to do in case of an empty response
lw_warning_empty <- function(){
  warning("No data returned", call. = FALSE)
  invisible(NULL)
}


# Compares two sets of parameters and raises a warning if they are different
lw_compare_parameters <- function(par_user, par_server){

  stopifnot(is.list(par_user))
  stopifnot(is.list(par_server))

  if(length(setdiff(par_user, par_server)) != 0){

    lw_print_parameters(par_user, "- Your query:")
    lw_print_parameters(par_server, "- Server query:")

    warning("The query applied on the server differ from the parameters you used. \n Hint: You may need an account to fully access the data under moratorium. \n Hint: Request access at: https://rshiny.lifewatch.be/account?p=register", call. = TRUE)

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
lw_check_lwdataserver <- function(force_opencpu = FALSE, ...){
  # Checks if lwdataserver is installed
  suppressWarnings(use_lwdataserver <- isTRUE(requireNamespace("lwdataserver", quietly = TRUE)))

  # If lwdataserver is installed, check config
  if(use_lwdataserver & !force_opencpu){
    use_lwdataserver <- lw_check_config(...) # changes to FALSE if secrets are not available
  }

  # If lwdataserver is not installed, or the configs are not available, or we want to force to use opencpu
  if(!use_lwdataserver | force_opencpu){
    message("- Query mode: Post request to OpenCPU server")
    use_lwdataserver <- FALSE
  }else if(use_lwdataserver & !force_opencpu){
    message("- Query mode: Database connection")
    use_lwdataserver <- TRUE
  }
   return(use_lwdataserver)
}

# Feed a character vector with the secrets and check if they are not empty
# Returns TRUE if all ok, FALSE if not and raises a warning
lw_check_config <- function(datatype = NA, test = FALSE, test_config = NA){

  if(test){
    config <- test_config
  }else{
    # Mongo config
    if(datatype %in% c("Bats data", "FlowCam data", "Genetic data", "ZooScan data")){
      config <- c("MONGODB_CONN", "MONGODBSANT1_CONN")
    }else if(datatype %in% c("acoustic data")){
      config <- c("MONGODB_CONN")
      # SQL config
    }else if(datatype %in% c("Buoy data", "CTD data", "MVB data", "Sample library", "Station data",
                             "TripActions data", "Underway data", "listMVBstations")){
      config <- c("ODBC_USER", "ODBC_PSWD")
      # ETN config
    }else if(datatype %in% c("CPOD data", "ETN data", "listETNprojects")){
      config <- c("ETN_ODBC_DSN", "ETN_SERVER", "ETN_DBNAME", "ODBC_USER", "ODBC_PSWD")
      # Uva Birds config
    }else if(datatype %in% c("UVA bird data", "listUVAtags")){
      config <- c("UVA_ODBC_DSN", "UVA_SERVER", "UVA_DBNAME", "ODBC_USER", "ODBC_PSWD")
      # EurObis configuration
    }else if(datatype %in% c("Eurobis data")){
      config <- c("EUROBIS_ODBC_DSN", "EUROBIS_SERVER", "EUROBIS_DBNAME", "ODBC_USER", "ODBC_PSWD")
      # if data type fails, then check all!
    }else{
      config <- c("MONGODB_CONN", "MONGODBSANT1_CONN", "ODBC_USER", "ODBC_PSWD",
                  "ETN_ODBC_DSN", "ETN_SERVER", "ETN_DBNAME",
                  "UVA_ODBC_DSN", "UVA_SERVER", "UVA_DBNAME",
                  "EUROBIS_ODBC_DSN", "EUROBIS_SERVER", "EUROBIS_DBNAME")
    }
  }


  # Check all configs in a loop
  checks <- unlist(lapply(config, Sys.getenv, unset = NA, names = TRUE))

  # If NA exists, raise warning execution as it won't work - redirect to opencpu
  if(anyNA(checks)){
    config_missing <- subset(names(checks), is.na(checks))
    warning(paste0(
      "Connection details are missing: ", paste0(config_missing, collapse = ", "), ". \n Query redirected to OpenCPU. \n Hint: Add the connection details to .renviron with `usethis::edit_r_environ()`."
    ), call. = FALSE)
    return(FALSE)
  }else{
    # Success!
    return(TRUE)
  }
}

# lw_check_config(c("etn_userid"))
# lw_check_config("etn_userid")
# lw_check_config(c("fakestuff1"))
# lw_check_config("fakestuff1")
# lw_check_config(c("etn_userid", "fakestuff1", "ODBC_USER"))
# lw_check_config(c("etn_userid", "fakestuff1", "fakestuff2", "fakestuff3", "ODBC_USER"))
# lw_check_config(c("etn_userid", "ODBC_USER"))

# "etn_userid", "etn_pw", "USER", "PW",
#
# "userid", "pwd",
#
# "ETN_SERVER", "ETN_ODBC_DSN", "ETN_DBNAME",
#
# "UVA_ODBC_DSN", "UVA_DBNAME", "UVA_SERVER",
#
# "EUROBIS_ODBC_DSN", "EUROBIS_SERVER", "EUROBIS_DBNAME",
#
# "ODBC_USER", "ODBC_PSWD",
#
# "MONGODB_CONN", "MONGODBSANT1_CONN"




# "etn_userid", "etn_pw", "USER", "PW",
# "userid", "pwd",
# "ETN_SERVER", "ETN_ODBC_DSN", "ETN_DBNAME",
# "UVA_ODBC_DSN", "UVA_DBNAME", "UVA_SERVER",
# "EUROBIS_ODBC_DSN", "EUROBIS_SERVER", "EUROBIS_DBNAME",
# "ODBC_USER", "ODBC_PSWD",
# "MONGODB_CONN", "MONGODBSANT1_CONN"
