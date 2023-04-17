
#' Run code using a temporary config file.
#'
#' This function takes inspiration from [withr::with_envvar()] and may be useful for
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
#'@param .extra_env_vars Additional environment variables to set.
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
    .active_config = c(R_CONFIG_ACTIVE = "default"),
    .extra_env_vars = NULL
){

  if (file.exists(config_yml)) {
    .config_file = c(R_CONFIG_FILE = config_yml)
  } else {
    .config_file <- write_yaml_as_file(config_yml)
  }

  new_envvars <- c(.active_config, .config_file, .extra_env_vars)
  old_envvars <- keep_old_envvars(new_envvars)
  on.exit(reset_envvars(old_envvars))
  set_new_envvars(new_envvars)
  force(code)
}

write_yaml_as_file <- function(config_yml) {
    new_file <- tempfile(pattern = "config", fileext = ".yml")
    cat(config_yml, file = new_file)
    c(R_CONFIG_FILE = new_file)
}


keep_old_envvars <- function(new_envvars) {
  Sys.getenv(names(new_envvars), names = TRUE, unset = NA)
}

set_new_envvars <- function(new_envvars) {
  do.call(Sys.setenv, as.list(new_envvars))
}

reset_envvars <- function(old_envvars) {
  set <- !is.na(old_envvars)
  if (any(set)) {
    do.call(Sys.setenv,  as.list(old_envvars[set]))
  }
  if (any(!set)) {
    reset <- names(old_envvars[!set])
    Sys.unsetenv(reset)
  }
}

