#' Currently active configurations
#'
#' Determine the currently active configurations.
#'
#' @return
#' A character vector with the name(s) of currently active configurations
#'
#' @details
#'
#' The names of currently active configurations are read from the
#' \code{R_CONFIG_ACTIVE} environment variable (configuration names
#' can be space or comma delimited). If the variable is not defined then
#' "default" is returned.
#'
#' @seealso \link{is_active}
#'
#' @export
active <- function() {
  strsplit(Sys.getenv("R_CONFIG_ACTIVE", "default"), "[, ]+")[[1]]
}


#' Test active configuration
#'
#' Check whether a configuration is currently active
#'
#' @param config Configuration name(s)
#'
#' @return
#' Logical vector indicating whether the specified configurations are active
#'
#' @seealso \link{active}
#'
#' @export
is_active <- function(config) {
  config %in% active()
}

