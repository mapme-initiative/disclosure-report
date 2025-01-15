# remotes::install_version("sf", version = "1.0-19", type = "source")
# remotes::install_github("mapme-initiative/mapme.biodiversity", ref = "proximity-indicators")
# renv::install("../pkgs/mapme.biodiversity", dependencies = FALSE)
renv::restore()
library(remotes) # for renv to be available
library(targets)
library(tibble)
####################### adjust the following inputs ############################
dir.create("data", showWarnings = FALSE)
locations <- "./data/locations.json"
output_significance <-  "./data/locations_biodiversity_significance.gpkg"
output_becs <-  "./data/locations_becs.gpkg"
code_column <- "nace_level"
opts <- list(
  datadir = "/vsiaz/mapme-data",
  rawdir = "/vsiaz/mapme-data/raw",
  max_cores = 4
)

# https://ec.europa.eu/competition/mergers/cases/index/nace_all.html
aoi_size <- tribble(
  ~code, ~size,
  "A", 10000,
  "B", 50000,
  "C", 20000,
  "D", 10000,
  "E", 20000,
  "F", 10000,
  "G", 5000,
  "H", 10000,
  "default", 20000
)
######################## leave untouched from here #############################
tar_option_set(
  packages = c(
    "sf",
    "dplyr",
    "tibble",
    "future",
    "progressr",
    "exactextractr",
    "mapme.biodiversity"
  )
)

tar_source("R")

list(
  tar_target(
    name = input,
    command = locations,
    format = "file"
  ),
  tar_target(
    name = data,
    command = prepare_locations(input, column = code_column, aoi_size = aoi_size),
  ),
  tar_target(
    name = indicators,
    command = run_mapme(data = data, opts = opts)
  ) ,
  tar_target(
    name = indicator_output,
    command = write_portfolio(indicators, dsn = "./data/aoi_indicators.gpkg"),
    format = "file"
  ),
  tar_target(
    name = significance,
    command = calc_significance(indicators),
  ),
  tar_target(
    name = significance_output,
    command = write_gpkg(significance, output_significance),
    format = "file"
  ),
  tar_target(
    name = becs,
    command = calc_becs(indicators),
  ),
  tar_target(
    name = becs_output,
    command = write_gpkg(becs, output_becs),
    format = "file"
  )
)
