write_gpkg <- function(dat, filename) {
  write_sf(dat, dsn = filename, delete_dsn = TRUE)

  return(filename)
}
