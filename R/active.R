#' Test active configuration
#'
#' Check whether a configuration is currently active
#'
#' @param config Configuration name
#' @return
#' Logical indicating whether the specified configuration is active
#'
#' @details
#' The name of the currently active configuration is read from the
#' \code{R_CONFIG_ACTIVE} environment variable. If the variable is
#' not defined then the "default" configuration is used.
#'
#' To test for whether a configuration is active you should use the
#' \code{\link{is_active}} function rather than inspecting the
#' environment variable directly (this is to so that tests remain
#' valid if other means of specifing configurations are introduced
#' in the future).
#'
#' @export
is_active <- function(config) {
  identical(config, Sys.getenv("R_CONFIG_ACTIVE", "default"))
}

