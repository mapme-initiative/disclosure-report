calc_becs <- function(indicators) {
  indicators <- mapme.biodiversity::portfolio_wide(indicators[, -which(names(indicators) == "org_geometry")],
                                                   indicators = c("mean_species_abundance", "star"))

  names(indicators)[grepl("abatement_max", names(indicators))] <- "abatement_value"
  names(indicators)[grepl("mean_species_abundance", names(indicators))] <- "mean_species_abundance"
  indicators$area_km2 <- as.numeric(units::set_units(sf::st_area(indicators), "km2"))

  indicators$becs_extent <- log10(indicators$area_km2)
  indicators$becs_condition <- indicators$mean_species_abundance
  indicators$becs_significance <- log10(indicators$abatement_value * 1000)

  indicators$becs <-
    indicators$becs_extent *
    indicators$becs_condition *
    indicators$becs_significance

  return(indicators)
}
