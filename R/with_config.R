
#' Run code using a temporary config file.
#'
#' This function is based on [withr::with_envvar()] and may be useful for
#' testing purposes.
#'
#' @param config_yml Either the path to a config file, or a character string
#'   representing a yaml configuration.
#'
#' @param code Code to execute in a temporary environment.
#'
#' @param .active_config A named character representing an environment variable.
#'   Passed to [withr::with_envvar()].
#'
#' @return The result of running the `code`, after having temporarily set the
#'   necessary environment variables.
#'
#' @export
#'
#' @example inst/examples/example_with_config.R
#'
with_config <- function(
    config_yml,
    code,
    .active_config = c(R_CONFIG_ACTIVE = "default")
){

  if (file.exists(config_yml)) {
    .config_file = c(R_CONFIG_FILE = config_yml)
  } else {
    new_file <- tempfile(pattern = "config", fileext = ".yml")
    .config_file = c(R_CONFIG_FILE = new_file)
    cat(config_yml, file = new_file)
  }

  new_envvars <- c(.active_config, .config_file)
  old_envvars <- Sys.getenv(names(new_envvars), names = TRUE, unset = NA)
  on.exit({
    set <- !is.na(old_envvars)
    if (any(set)) {
      do.call(Sys.setenv,  as.list(old_envvars[set]))
    }
    if (any(!set)) {
      reset <- names(old_envvars[!set])
      Sys.unsetenv(reset)
    }
  })
  do.call(Sys.setenv, as.list(new_envvars))
  force(code)
}


