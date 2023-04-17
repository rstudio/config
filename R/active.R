#' Test active configuration.
#'
#' Check whether a configuration is currently active.
#'
#' The name of the currently active configuration is read from the
#' `R_CONFIG_ACTIVE` environment variable. If the variable is not defined then
#' the "default" configuration is used.
#'
#' To test for whether a configuration is active you should use the
#' [is_active()] function rather than inspecting the environment variable
#' directly (this is to so that tests remain valid if other means of specifying
#' configurations are introduced in the future).
#'
#' @param config Configuration name
#'
#' @return Logical indicating whether the specified configuration is active
#'
#' @seealso [get()]
#'
#' @export
is_active <- function(config) {
  identical(config, Sys.getenv("R_CONFIG_ACTIVE", "default"))
}

