poly_signficiance <- function(x, aoi) {
  if(is.null(x)) return("none")
  dist <- tibble::tribble(
    ~ aoi, ~ distance, ~ level,
    5000,  5000, "low",
    10000, 10000, "low",
    20000, 20000, "low",
    50000, 50000, "low",
    5000,  1500, "medium",
    10000,  3000, "medium",
    20000,  6000, "medium",
    50000, 15000, "medium",
    5000,   500, "high",
    10000,  1000, "high",
    20000,  2000, "high",
    50000,  5000, "high"
  )
  tmp <- dplyr::filter(dist, aoi == {{aoi}}) |>
    dplyr::arrange(desc(distance))
  index <- x$value > tmp$distance
  if(!any(index)) return("high")
  return(tmp$level[which(index)[1]])
}

star_significance <- function(x, what = c("abatement", "restoration")) {
  if(is.null(x)) return("none")

  what <- match.arg(what)
  vals <- tibble::tribble(
    ~ layer, ~ value, ~ level,
    "abatement",  0.05, "low",
    "abatement",  0.15, "medium",
    "restoration", 0.02, "low",
    "restoration", 0.05, "medium"
  )

  tmp <- dplyr::filter(vals, layer == {{what}}) |>
    dplyr::arrange(value)

  value <- dplyr::filter(x, grepl(what, variable)) |>
    dplyr::pull(value)

  index <- value < tmp$value
  if (!any(index)) return("high")
  return(tmp$level[which(index)[1]])

}

classify_significance <- function(x) {
  if(any(x == "high")) return("high")
  if(any(x == "medium")) return("medium")
  if(any(x == "low")) return("low")
  return("none")
}

calc_significance <- function(indicators) {

  indicators$wdpa_significance <- purrr::map2_chr(
    indicators$proximity_wdpa,
    indicators$aoi_size,
    poly_signficiance)

  indicators$kba_significance <- purrr::map2_chr(
    indicators$proximity_kba,
    indicators$aoi_size,
    poly_signficiance)

  indicators$abatement_significance <- purrr::map_chr(
    indicators$star,
    star_significance,
    what = "abatement"
  )

  indicators$restoration_significance <- purrr::map_chr(
    indicators$star,
    star_significance,
    what = "restoration"
  )

  indicators <- indicators |>
    dplyr::rowwise() |>
    dplyr::mutate(significance = classify_significance(dplyr::c_across(dplyr::contains("_significance"))))

  indicators <- mapme.biodiversity::portfolio_wide(indicators[, -which(names(indicators) == "org_geometry")])
  names(indicators)[grepl("proximity_wdpa", names(indicators))] <- "proximity_wdpa"
  names(indicators)[grepl("proximity_kba", names(indicators))] <- "proximity_kba"
  names(indicators)[grepl("species_richness", names(indicators))] <- "species_richness"
  names(indicators)[grepl("abatement_max", names(indicators))] <- "abatement_value"
  names(indicators)[grepl("restoration_max", names(indicators))] <- "restoration_value"
  names(indicators)[grepl("mean_species_abundance", names(indicators))] <- "mean_species_abundance"

  indicators$becs <-
    log10(as.numeric(units::set_units(sf::st_area(sf::st_sf(indicators)), "km2"))) *
    indicators$mean_species_abundance *
    log10(indicators$abatement_value * 1000)

  indicators
}
