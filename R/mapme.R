run_mapme_significance <- function(
    data,
    opts) {
  mapme_options(outdir = opts$datadir)
  get_resources(
    data,
    get_wdpa(version = "Oct2024"),
    get_key_biodiversity_areas(path = file.path(opts$rawdir, "kbas.gpkg")),
    get_iucn(paths = file.path(opts$rawdir, "Combined_THR_SR_2023.tif")),
    get_star(layer = "both")
  )

  if(interactive()) p <- multisession else p <- multicore
  plan(p, workers = opts$max_cores)
  with_progress({
    data_inds <- calc_indicators(
      data,
      calc_proximity_wdpa(asset_column = "org_geometry"),
      calc_proximity_kba(asset_column = "org_geometry"),
      calc_species_richness(stats = "max", engine = "exactextract"),
      calc_star(stat = "max", engine = "exactextract")
    )
  }, enable = TRUE)
  plan(sequential)

  data_inds
}

run_mapme_becs <- function(
    data,
    opts) {
  mapme_options(outdir = opts$datadir)
  get_resources(
    data,
    get_star(layer = "abatement"),
    get_mean_species_abundance(path = file.path(opts$rawdir, "TerrestrialMSA_2015_World.tif"))
  )

  if(interactive()) p <- multisession else p <- multicore
  plan(p, workers = opts$max_cores)
  with_progress({
    data_inds <- calc_indicators(
      data,
      calc_star(stat = "max", engine = "exactextract"),
      calc_mean_species_abundance()
    )
  }, enable = TRUE)
  plan(sequential)

  data_inds
}
