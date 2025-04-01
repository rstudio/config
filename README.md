
<!-- README.md is generated from README.Rmd. Please edit that file -->

<style>
.codeblock-label {
  color: #000;
  display: inline-block;
  border-top-left-radius: .5rem;
  border-top-right-radius: .5rem;
  padding: 0.25rem 0.75rem;
  background-color: #cccccc;
  margin-bottom: 0;
  font-size: 0.875em;
  font-family: var(--bs-font-monospace);
}
  &#10;.codeblock-label + div.sourceCode {
  margin-top: 0;
}
</style>

# config <img src='man/figures/logo.svg' align="right" height="139" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/config)](https://CRAN.R-project.org/package=config)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/miniCRAN)](https://www.r-pkg.org/pkg/miniCRAN)
[![R-CMD-check](https://github.com/rstudio/config/workflows/R-CMD-check/badge.svg)](https://github.com/rstudio/config/actions)
[![Codecov test
coverage](https://codecov.io/gh/rstudio/config/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rstudio/config?branch=main)
<!-- badges: end -->

The `config` package makes it easy to manage environment specific
configuration values. For example, you might want to use distinct values
for development, testing, and production environments.

## Installation

You can install the `config` package from CRAN by using:

``` r
install.packages("config")
```

## Usage

To use `config`, create a file `config.yml` with default as well as
other arbitrary configurations. For example:

<p class="codeblock-label">

config.yml
</p>

``` yaml
default:
  trials: 5
  dataset: "data-sampled.csv"
  
production:
  trials: 30
  dataset: "data.csv"
```

To read configuration values you call the `config::get` function, which
returns a list containing all of the values for the currently active
configuration:

<p class="codeblock-label">

R
</p>

``` r
config <- config::get()
config$trials
#> [1] 5
config$dataset
#> [1] "data-sampled.csv"
```

You can also read a single value from the configuration as follows:

<p class="codeblock-label">

R
</p>

``` r
config::get("trials")
#> [1] 5
config::get("dataset")
#> [1] "data-sampled.csv"
```

The `config::get()` function takes an optional `config` argument which
determines which configuration to read values from (the “default”
configuration is used if none is specified).

## Vignettes

See the package vignettes at <https://rstudio.github.io/config/> for
more examples and instructions for advanced usage, including:

- Inheritance and R expressions
- Using `config` on Posit Connect

## Do not attach the package using `library(config)`

We strongly recommend you use `config::get()` rather than attaching the
package using `library(config)`.

In fact, we strongly recommend you never use `library(config)`.

The underlying reason is that the `get()` and `merge()` functions in
`{config}` will mask these functions with the same names in base R.
