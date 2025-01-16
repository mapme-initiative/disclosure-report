calc_becs <- function(indicators) {
  indicators <- mapme.biodiversity::portfolio_wide(indicators,
                                                   indicators = c("mean_species_abundance", "star"))
  indicators$proximity_kba <- NULL
  indicators$proximity_wdpa <- NULL
  indicators$species_richness <- NULL
  indicators$`star_2019-01-01_restoration_max_unitless` <- NULL
  names(indicators)[grepl("abatement_max", names(indicators))] <- "abatement_value"
  names(indicators)[grepl("mean_species_abundance", names(indicators))] <- "mean_species_abundance"
  indicators$area_km2 <- as.numeric(units::set_units(sf::st_area(sf::st_sf(indicators)), "km2"))

  indicators$becs_extent <- log10(indicators$area_km2)
  indicators$becs_condition <- indicators$mean_species_abundance
  indicators$becs_significance <- log10(indicators$abatement_value * 1000)

  indicators$becs <-
    indicators$becs_extent *
    indicators$becs_condition *
    indicators$becs_significance

  return(indicators)
}
