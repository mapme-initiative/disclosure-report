
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

> \[!IMPORTANT\]  
> This pipelines requires the
> [`proximity-indicators`](https://github.com/mapme-initiative/mapme.biodiversity/tree/proximity-indicators)
> branch of `mapme.biodiversity` to be installed.

# disclosure-report

This repository contains code that mimics [IBAT’s disclosure preparation
report](https://www.ibat-alliance.org/sample-downloads) as a
reproducible [`{targets}`](https://books.ropensci.org/targets/)
pipeline.

While we do not produce PDF reports here, we go beyond IBAT’s
functionality in the regard of calculating the required indicators for
entire portfolios using
[`mapme.bidiversity`](https://github.com/mapme-initiative/mapme.biodiversity).

The required inputs are:

- `data/locations.json`: An input file representing project locations
  with attributes available to spefiy the area of influence (see below).

The key part of this pipeline is that you can customize the area of
influence (or buffer zones) to be used for your locations. For this, you
need to change the values of the variables `code_column` and `aoi_size`
you can find in the header of [`_targets.R`](_targets.R). `code_column`
identifies the column in the input data to be linked via the `code`
column in `aoi_size` to an associated buffer size. Note, that codes not
present in `aoi_size` will be encoded with the `default` value.

The pipeline then calculates the respective indicators within the area
of influence for each location. These are:

- proximity to protected areas
- proximity to key biodiversity areas
- number of threatened species
- maximum value of STAR layers threat abatement and restoration

These are individually scored to their biodiversity significance in
accordance to the IBAT workflow. A site also receives a total
biodiversity significance score equal to the highest score of the
individual components (none, low, medium, and high).

The codes are structured in the following way:

- [`inputs.R`](R/inputs.R): read inputs and calculate area of influence
- [`mapme.R`](R/mapme.R): calculate the required indicators
- [`significance.R`](R/significance.R): calculation of significance
  scores

To run the pipeline, adjust [`_targets.R`](_targets.R) to point towards
your input file and run the following from a shell:

``` shell
$ Rscript -e 'targets::tar_make()'
```

Below you can find the visualisation of the pipeline’s targets:

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x2db1ec7a48f65a9b([""Outdated""]):::outdated --- xd03d7c7dd2ddda2b([""Stem""]):::none
  end
  subgraph Graph
    direction LR
    xa538c4711b193115(["significance"]):::outdated --> x21a9e021e2a8eb5c(["significance_output"]):::outdated
    x148bea66679381e8(["indicators"]):::outdated --> xa538c4711b193115(["significance"]):::outdated
    x148bea66679381e8(["indicators"]):::outdated --> xd7196846cd1935c0(["indicator_output"]):::outdated
    x9755545176a05140(["data"]):::outdated --> x148bea66679381e8(["indicators"]):::outdated
    x2ee4157c3daee3b7(["input"]):::outdated --> x9755545176a05140(["data"]):::outdated
  end
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```
