
<!-- README.md is generated from README.Rmd. Please edit that file -->

# disclosure-report

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Skipping install of ‘mapme.biodiversity’ from a github remote, the SHA1
(5ad979a8) has not changed since last install. Use `force = TRUE` to
force installation

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    xf1522833a4d242c5([""Up to date""]):::uptodate --- x2db1ec7a48f65a9b([""Outdated""]):::outdated
    x2db1ec7a48f65a9b([""Outdated""]):::outdated --- xd03d7c7dd2ddda2b([""Stem""]):::none
  end
  subgraph Graph
    direction LR
    xa538c4711b193115(["significance"]):::outdated --> x21a9e021e2a8eb5c(["significance_output"]):::outdated
    x148bea66679381e8(["indicators"]):::uptodate --> xa538c4711b193115(["significance"]):::outdated
    x148bea66679381e8(["indicators"]):::uptodate --> xd7196846cd1935c0(["indicator_output"]):::outdated
    x9755545176a05140(["data"]):::uptodate --> x148bea66679381e8(["indicators"]):::uptodate
    x2ee4157c3daee3b7(["input"]):::uptodate --> x9755545176a05140(["data"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
```

``` shell
$ Rscript -e 'targets::tar_make()'
```
