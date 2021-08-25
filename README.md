
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lwdataexplorer

<!-- badges: start -->

<!-- badges: end -->

Access to [LifeWatch Belgium](lifewatch.be/) data hosted by the
[Flanders Marine Institute (VLIZ)](https://www.vliz.be/) in
[R](https://www.r-project.org/).

See the package website: <https://lifewatch.github.io/lwdataexplorer/>

## Installation

You can install the development version of deleteme from
[GitHub](https://github.com/lifewatch/lwdataexplorer) using
[devtools](https://github.com/r-lib/devtools):

``` r
# install.packages("devtools")
devtools::install_github("lifewatch/lwdataexplorer")
```

## Usage

The package `lwdataexplorer` retrieves biodiversity, environmental or
genetic data from the projects supported by LifeWatch Belgium. These
data is also available to explore and download through the LifeWatch
Data Explorer: an R Shiny application that allows you to check and
download data from your browser.

You can find more information about these projects and the LifeWatch
Data Explorer in this link: -
<https://www.lifewatch.be/en/lifewatch-data-explorer>

There is a function for each specific data type. For instance, to
retrieve data from the moonitoring buoy on the Belgian Part of the North
Sea:

``` r
library(lwdataexplorer)
library(tibble) # only for visualizing

df <- getBuoyData("2021-03-19", "2021-04-21", "All")
#> No encoding supplied: defaulting to UTF-8.
#> Query parameters
#> ---------------------------------------------
#> daterange : c("2021-03-19", "2021-04-21")
#> stationlist : All
#> type : Buoy data
#> ---------------------------------------------
#> Data dimension: (2384 x 23)

as_tibble(df)
#> # A tibble: 2,384 × 23
#>    STATION      TIME       LATITUDE LONGITUDE `AIR TEMPERATURE… `ATMPRESS (MBAR…
#>    <chr>        <chr>         <dbl>     <dbl>             <dbl>            <dbl>
#>  1 Buoy in Spu… 2021-03-1…     51.2      2.95              6.35            1022.
#>  2 Ostend Rese… 2021-03-1…     51.2      2.92              6.10              NA 
#>  3 Spuikom Slu… 2021-03-1…     51.2      2.94             NA                 NA 
#>  4 Spuikom Slu… 2021-03-1…     51.2      2.94             NA                 NA 
#>  5 Buoy in Spu… 2021-03-1…     51.2      2.95              5.66            1023.
#>  6 Ostend Rese… 2021-03-1…     51.2      2.92              5.56              NA 
#>  7 Buoy in Spu… 2021-03-1…     51.2      2.95              5.40            1024.
#>  8 Ostend Rese… 2021-03-1…     51.2      2.92              5.25              NA 
#>  9 Spuikom Slu… 2021-03-1…     51.2      2.94             NA                 NA 
#> 10 Spuikom Slu… 2021-03-1…     51.2      2.94             NA                 NA 
#> # … with 2,374 more rows, and 17 more variables:
#> #   AVG WIND DIRECTION (DEG) <dbl>, AVG WIND SPEED (M/S) <dbl>,
#> #   RELHUMIDITY (%) <dbl>, SOLARENERGY (W/M²) <dbl>, VOLTAGE (V) <dbl>,
#> #   ATMPRESS(MBAR) <dbl>, RELHUMIDITY(%) <dbl>,
#> #   LEVEL HARBOUR (MTAW) 1MIN <dbl>, LEVEL HARBOUR (MTAW) <dbl>,
#> #   LEVEL SPUIKOM (MTAW) <dbl>, RAIN15 (MM) <dbl>, NO3 (PPB) <dbl>,
#> #   SIO2 (PPB) <dbl>, RAIN (MM) <dbl>, DO (MG/L) <int>, SALINITY (PSU) <int>,
#> #   WATER TEMPERATURE (°C) <int>
```

Note that the functions naming includes always the `get` word, followed
by the data type.

``` r
# Functions available in the package
ls("package:lwdataexplorer")
#>  [1] "getBatsData"     "getBuoyData"     "getCpodData"     "getEtnData"     
#>  [5] "getFlowcamData"  "getMvbData"      "getStationData"  "getUnderwayData"
#>  [9] "getUvaBirdData"  "getZooscanData"  "listEtnProjects" "listMvbStations"
#> [13] "listUvaTags"     "lwdata"          "lwdata2"
```

### Query parameters

To find more information about the query parameters you can check the
help page of each function which include some basic examples. For
example, to see the help page of the function that retrieves data from
the European Tracking Network (ETN):

``` r
# Open the help page and go over the examples
?getEtnData()
```

### Data under moratorium

Some data types are temporarily under embargo due to the project
requirements. To help you to know if the query you are applying was
restricted, the query parameters are always printed in the console. If
the query parameters you requested were **restricted on the server
side**, a warning will be raised and both your query parameters and
those applied in the server will be printed in the console.

The example below tries to request some data from the Meetnet Vlaams
Banken (MVB). However, without an account some restrictions are applied:
(1) parameter is ‘Tide TAW’, (2) Time grouping is day or hour and (3)
dates are only between the last 30 days.

``` r
# This will raise a warning
mvb <- getMvbData("2020-01-01", "2020-12-31", parameters = 'All', 
                  stations = "All", by = "10min", calc = "none", 
                  params = TRUE)
#> No encoding supplied: defaulting to UTF-8.
#> Your query:
#> ---------------------------------------------
#> daterange : c("2020-01-01", "2020-12-31")
#> type : MVB data
#> stations : All
#> calc : none
#> binSize : 10min
#> parameters : All
#> ---------------------------------------------
#> Server query:
#> ---------------------------------------------
#> daterange : c("2021-07-26", "2020-12-31")
#> type : MVB data
#> stations : All
#> calc : none
#> binSize : day
#> parameters : Tide TAW
#> ---------------------------------------------
#> Warning in outputQC(input, out): The query applied on the server differ from the parameters you used. 
#> Hint: You may need an account to fully access the data under moratorium. 
#> Hint: Request access at: https://rshiny.lifewatch.be/account?p=register
#> Warning in outputQC(input, out): No data returned. Try relaxing query
#> parameters.
```

### Get data and query parameters in a list

The example above used set the argument `params = TRUE`. Through this
argument, the get functions will return a list with both the data and
another list with the query parameters applied in the server

``` r
# Check object type
class(mvb)
#> [1] "list"

# What are the elements of the list?
names(mvb)
#> [1] "mdf" "par"

# Get query parameters as a list
mvb$par
#> $daterange
#> [1] "2021-07-26" "2020-12-31"
#> 
#> $type
#> [1] "MVB data"
#> 
#> $stations
#> [1] "All"
#> 
#> $calc
#> [1] "none"
#> 
#> $binSize
#> [1] "day"
#> 
#> $parameters
#> [1] "Tide TAW"
```

### Wrapper functions

Besides the functions that start with `get`, you can use the `lwdata`
function. This is a wrapper for all the other `get` functions. You have
to provide the data type as an argument and all the other query
parameters for the specific data type. Find more info with `?lwdata()`

For instance, You can request the list of ETN projects with its specific
function `listETNprojects()` or using `lwdata()`:

``` r
etn <- lwdata('listETNprojects')
#> No encoding supplied: defaulting to UTF-8.

as_tibble(etn)
#> # A tibble: 169 × 2
#>    name                     type   
#>    <chr>                    <chr>  
#>  1 2004_Gudena              network
#>  2 2011_Loire               network
#>  3 2011_Warnow              network
#>  4 2013_Foyle               network
#>  5 2013_Maas                network
#>  6 2014_Nene                network
#>  7 2015_PhD_Gutmann_Roberts network
#>  8 2016_Diaccia_Botrona     network
#>  9 2017_Fremur              network
#> 10 2019_Grotenete           network
#> # … with 159 more rows
```

## More information

### Issues

If you find any problems please (raise a new
issue)\[<https://github.com/lifewatch/lwdataexplorer/issues>\] or
contact the package maintainer:

``` r
# Run once the package is installed
maintainer("lwdataexplorer")
```

### Citation

Please cite this software as:

``` r
citation("lwdataexplorer")
#> 
#> To cite package 'lwdataexplorer' in publications use:
#> 
#>   Francisco Hernandez, Nick Dillen and Salvador Fernández-Bejarano
#>   (2021). lwdataexplorer: Access to data from the LifeWatch Data
#>   Explorer. R package version 0.0.0.9000.
#>   https://www.lifewatch.be/en/lifewatch-data-explorer
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {lwdataexplorer: Access to data from the LifeWatch Data Explorer},
#>     author = {Francisco Hernandez and Nick Dillen and Salvador Fernández-Bejarano},
#>     year = {2021},
#>     note = {R package version 0.0.0.9000},
#>     url = {https://www.lifewatch.be/en/lifewatch-data-explorer},
#>   }
```

### License

See the license file.

``` r
packageDescription("lwdataexplorer", fields="License")
#> [1] "MIT + file LICENSE"
```
