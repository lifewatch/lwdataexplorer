
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
#> - Query mode: Database connection
#> Date passed as text. Trying to transform to date
#> - Query parameters:
#>    - daterange: c("2021-03-19", "2021-04-21")
#>    - stationlist: All
#>    - type: Buoy data

as_tibble(df)
#> # A tibble: 2,384 × 39
#>    Station               Time                Latitude Longitude `Air temperatur…
#>    <fct>                 <dttm>                 <dbl>     <dbl>            <dbl>
#>  1 Buoy in Spuikom       2021-03-19 00:00:00     51.2      2.95             6.35
#>  2 Ostend Research Tower 2021-03-19 00:00:00     51.2      2.92             6.10
#>  3 Spuikom Sluice        2021-03-19 00:00:00     51.2      2.94            NA   
#>  4 Spuikom Sluice        2021-03-19 01:00:00     51.2      2.94            NA   
#>  5 Buoy in Spuikom       2021-03-19 01:00:00     51.2      2.95             5.66
#>  6 Ostend Research Tower 2021-03-19 01:00:00     51.2      2.92             5.56
#>  7 Buoy in Spuikom       2021-03-19 02:00:00     51.2      2.95             5.40
#>  8 Ostend Research Tower 2021-03-19 02:00:00     51.2      2.92             5.25
#>  9 Spuikom Sluice        2021-03-19 02:00:00     51.2      2.94            NA   
#> 10 Spuikom Sluice        2021-03-19 03:00:00     51.2      2.94            NA   
#> # … with 2,374 more rows, and 34 more variables: AtmPress(mBar) <dbl>,
#> #   Avg Wind direction (deg) <dbl>, Avg Wind speed (m/s) <dbl>,
#> #   Chlorophyll (µg/L) <dbl>, Conductivity (mS/cm) <dbl>,
#> #   Dissolved oxygen (µM) <dbl>, DO (mg/l) <dbl>, Level Harbour (mTAW) <dbl>,
#> #   Level Spuikom (mTAW) <dbl>, NH3 (ppb) <dbl>, NO3 (ppb) <dbl>,
#> #   Oxygen sat. (%) <dbl>, pCO2 air (ppm) <dbl>, pH (raw) <dbl>,
#> #   PO4 (ppb) <dbl>, Rain (mm) <dbl>, Rain15 (mm) <dbl>, …
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
#> - Query mode: Database connection
#> - Your query:
#>    - daterange: c("2020-01-01", "2020-12-31")
#>    - type: MVB data
#>    - stations: All
#>    - calc: none
#>    - binSize: 10min
#>    - parameters: All
#> - Server query:
#>    - daterange: c("2021-10-31", "2020-12-31")
#>    - type: MVB data
#>    - stations: All
#>    - calc: none
#>    - binSize: day
#>    - parameters: Tide TAW
#> Warning in lw_compare_parameters(input, par): The query applied on the server differ from the parameters you used.
#> Hint: You may need an account to fully access the data under moratorium.
#> Hint: Request access at: https://rshiny.lifewatch.be/account?p=register
#> Warning in lw_warning_empty(): No data returned
```

### Get data and query parameters in a list

You can request to get the parameters applied in the server by setting
the argument `params = TRUE`. The get functions will return a list with
both the data and another list with the query parameters applied in the
server

``` r
# Request data but with parameters this time
data_with_params <- getBuoyData("2021-03-19", "2021-04-21", "All", params = TRUE)
#> - Query mode: Database connection
#> Date passed as text. Trying to transform to date
#> - Query parameters:
#>    - daterange: c("2021-03-19", "2021-04-21")
#>    - stationlist: All
#>    - type: Buoy data

# Check object type
class(data_with_params)
#> [1] "list"

# What are the elements of the list?
names(data_with_params)
#> [1] "mdf" "par"

# Get query parameters as a list
data_with_params$par
#> $daterange
#> [1] "2021-03-19" "2021-04-21"
#> 
#> $stationlist
#> [1] "All"
#> 
#> $type
#> [1] "Buoy data"
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
#> - Query mode: Database connection

as_tibble(etn)
#> # A tibble: 192 × 2
#>    name                     type   
#>    <fct>                    <chr>  
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
#> # … with 182 more rows
```

### Boost performance

If you are working in one of the LifeWatch Belgium RStudio server, for
example <https://rstudio.lifewatch.be/> or
<https://rstudio.vsc.lifewatch.be>, you can make your queries run
faster. For more information please contact the package maintainer to
discuss permissions and configuration.

## More information

### Issues

If you find any problems please [raise a new
issue](https://github.com/lifewatch/lwdataexplorer/issues) or contact
the package maintainer:

``` r
# Run once the package is installed
maintainer("lwdataexplorer")
```

### Citation

Please cite this software as:

> Francisco Hernandez, Nick Dillen and Salvador Fernández-Bejarano
> (2021). lwdataexplorer: Access to data from the LifeWatch Data
> Explorer. R package version 0.0.0.9000.
> <https://lifewatch.github.io/lwdataexplorer/>

### License

See the license file.

``` r
packageDescription("lwdataexplorer", fields="License")
#> [1] "MIT + file LICENSE"
```
