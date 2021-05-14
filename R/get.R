
#' Read configuration values.
#'
#' Read from the currently active configuration, retrieving either a
#' single named value or all values as a list.
#'
#' For additional details see the package website at
#'  \href{https://github.com/rstudio/config}{https://github.com/rstudio/config}.
#'
#' @param value Name of value (`NULL` to read all values)
#'
#' @param config Name of configuration to read from. Defaults to
#'   the value of the `R_CONFIG_ACTIVE` environment variable
#'   ("default" if the variable does not exist).
#'
#' @param file Configuration file to read from (defaults to
#'   `"config.yml"`). If the file isn't found at the location
#'   specified then parent directories are searched for a file
#'   of the same name.
#'
#' @param use_parent `TRUE` to scan parent directories for
#'   configuration files if the specified config file isn't found.
#'
#' @return The requested configuration value (or all values as
#'   a list of `NULL` is passed for `value`).
#'
#' @return A list, or vector, corresponding to the contents of the config file.
#'
#' @seealso [is_active()], [merge()]
#'
#' @export
get <- function(value = NULL,
                config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
                file = Sys.getenv("R_CONFIG_FILE", "config.yml"),
                use_parent = TRUE) {

  # find the file (scan parent directories above if need be)
  file <- normalizePath(file, mustWork = FALSE)
  if (use_parent) {
    while (!file.exists(file)) {
      # normalize path
      file <- normalizePath(file, mustWork = FALSE)

      # check if we are at the end of the search
      file_dir <- normalizePath(dirname(file), mustWork = FALSE)
      parent_dir <- normalizePath(dirname(file_dir), mustWork = FALSE)
      if (file_dir == parent_dir)
        break

      # search one directory up
      file <- file.path(parent_dir, basename(file))
    }
  }

  # check for file existence
  if (!file.exists(file)) {
    stop("Config file ", basename(file), " not found in current working ",
         "directory", ifelse(use_parent, " or parent directories", ""))
  }

  # load the yaml
  config_yaml <- yaml::yaml.load_file(
    file, eval.expr = FALSE, handlers = list(expr = function(x) parse(text = x))
  )

  # get the default config (required)
  default_config <- config_yaml[["default"]]
  if (is.null(default_config))
    stop("You must provide a default configuration.")

  # get the value and check for / validate inheritance
  do_get <- function(config, inherited = c()) {

    # error if the requested config is already in our inheritance chain
    if (config %in% inherited[-1])
      stop("Configuration ", config, " inherits from itself!", call. = FALSE)

    # get the requested config
    active_config <- config_yaml[[config]]

    # if it isn't the default configuration then see if it inherits from
    # another configuration. if it does then resolve and merge with it,
    if (!identical(config, "default")) {
      for (cfg in active_config$inherits) {
        active_config <- merge_lists(do_get(cfg, c(cfg, inherited)),
                                     active_config)
      }
    }

    # return the config
    active_config
  }

  # merge the specified configuration with the default configuration
  active_config <- merge_lists(default_config, do_get(config))

  # check whether any expressions need to be evaluated recursively

  eval_issues <- list()
  eval_env = new.env(parent = baseenv())
  eval_fun <- function(expr, envir) {
    tryCatch(
      eval(expr, envir = envir),
      error = function(e) {
        eval_issues <<- append(
          eval_issues,
          paste(deparse(e$call), e$message, sep = ": ")
        )
        NULL
      })
  }
  eval_recursively <- function(x, level = 1) {
    is_expr <- vapply(x, is.expression, logical(1))
    is_list <- vapply(x, is.list, logical(1))

    if (level == 1) {
      eval_env <- list2env(x[!is_expr & !is_list], envir = eval_env)
    }
    x[is_expr & !is_list] <- lapply(x[is_expr & !is_list], eval_fun, envir = eval_env)
    x[is_list] <- lapply(x[is_list], eval_recursively, level = level + 1)
    x
  }

  active_config <- eval_recursively(active_config)

  if (length(eval_issues)) {
    msg <- paste("Attempt to assign nested list value from expression.",
                 "Only directly assigned values can be used in expressions.",
                 ngettext(length(eval_issues), "Original Error:\n",
                          "Original Errors:\n"),
                 sep = "\n")
    stop(msg, paste("* ", eval_issues, collapse = "\n"), call. = TRUE)
  }

  # return either the entire config or a requested value
  if (!is.null(value))
    active_config[[value]]
  else
    structure(active_config, config = config, file = file)
}

