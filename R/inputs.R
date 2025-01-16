prepare_locations_significance <- function(input, column, aoi_size) {

  stopifnot(names(aoi_size) == c("code", "size"))
  data <- read_sf(input)
  stopifnot(st_is_longlat(data))

  types <- data[[column]]
  types[is.na(types)] <- "default"
  stopifnot(all(unique(types) %in% aoi_size$code))
  buffer_size <- aoi_size$size[match(types, aoi_size$code)]

  data_buffered <- st_buffer(data, buffer_size)
  st_geometry(data_buffered) <- "geometry"
  data_buffered$aoi_size  <- buffer_size
  data_buffered$org_geometry <- st_geometry(data)
  data_buffered
}

prepare_locations_becs <- function(input) {
  data_becs <- read_sf(input)
  return(data_becs)
}
