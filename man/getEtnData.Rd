% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lwdataFunctions.R
\name{getEtnData}
\alias{getEtnData}
\title{Retrieve ETN-data from the LifeWatch project}
\usage{
getEtnData(
  startdate,
  stopdate,
  action,
  by,
  networks,
  projects,
  usr = NULL,
  pwd = NULL,
  params = FALSE,
  ...
)
}
\arguments{
\item{startdate}{Starting date for the query}

\item{stopdate}{Stopping date for the query}

\item{action}{One of ('Time bins','Residencies','Active network','Detections')}

\item{by}{Sample period, one of ("1 day", "1 week", "60 min","10 min", "1 min")}

\item{networks}{List of networks to be included in the query. See \code{\link{listEtnProjects}}.}

\item{projects}{List of projects to be included in the query. See \code{\link{listEtnProjects}}.}

\item{usr}{Username to connect to ETN database}

\item{pwd}{Password to connect to ETN database}

\item{params}{If TRUE, returns a list with the dataset and the query parameters applied in the server side. IF FALSE returns only the data.}

\item{...}{Reserved for internal use.}
}
\value{
Dataframe with the specified ETN data.
}
\description{
Retrieves the European Tracking Network (ETN) data from the LifeWatch project.
Need valid authentication to access the entire data. To get an account, register via the \href{http://rshiny.lifewatch.be/account?p=register}{Lifewatch RShiny registration} webpage.
}
\examples{
getEtnData("2020-04-19", "2020-04-21", action = "Time bins", by = "1 day",
networks = "All", projects = "All")
getEtnData("2016-01-01", "2017-12-31", action = "All", by = "1 week",
networks = "Azorean acoustic receiver network", projects = "Lifewatch", params = TRUE)
}
