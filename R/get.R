
#' Read configuration values
#'
#' Read from the currently active configuration, retreiving either a
#' single named value or all values as a list.
#'
#' @param value Name of value (\code{NULL} to read all values)
#' @param config Name of configuration to read from. Defaults to
#'   the value of the \code{R_CONFIG_NAME} environment variable
#'   ("default" if the variable does not exist).
#' @param file Configuration file to read from (defaults to
#'   "config.yml").
#'
#' @return The requested configuration value (or all values as
#'   a list of \code{NULL} is passed for \code{value}).
#'
#' @export
get <- function(value = NULL,
                config = Sys.getenv("R_CONFIG_NAME", "default"),
                file = "config.yml") {

  # load the yaml
  config_yaml <- yaml::yaml.load_file(file)

  # merge local config (if any)
  local_config_file <- file_with_meta_ext(file, "local")
  if (file.exists(local_config_file)) {
    local_config_yaml <- yaml::yaml.load_file(local_config_file)
    config_yaml <- merge_lists(config_yaml, local_config_yaml)
  }

  # get the default config (required)
  default_config <- config_yaml[["default"]]
  if (is.null(default_config))
    stop("You must provide a default configuration.")

  # validate that the requested value exists in the default config
  # (all values must have a default)
  if (!is.null(value) && is.null(default_config[[value]]))
    stop("The value '", value, "' does not have a default value specified")

  # get the requested config
  active_config <- config_yaml[[config]]

  # if it isn't the default configuration then see if it inherits from
  # another configuration. if it does then resolve and merge with it,
  # if not then merge with the default
  if (!identical(config, "default")) {
    inherits <- active_config$inherits
    if (!is.null(inherits))
      active_config <- merge_lists(config::get(config = inherits, file = file),
                                   active_config)
    else
      active_config <- merge_lists(default_config, active_config)
  }

  # return either the entire config or a requested value
  if (!is.null(value))
    active_config[[value]]
  else
    active_config
}

# recursively merge two lists (extracted from code used by rmarkdown
# package to merge _output.yml, _site.yml, front matter, etc.:
# https://github.com/rstudio/rmarkdown/blob/master/R/util.R#L174)
merge_lists <- function (base_list, overlay_list, recursive = TRUE) {
  if (length(base_list) == 0)
    overlay_list
  else if (length(overlay_list) == 0)
    base_list
  else {
    merged_list <- base_list
    for (name in names(overlay_list)) {
      base <- base_list[[name]]
      overlay <- overlay_list[[name]]
      if (is.list(base) && is.list(overlay) && recursive)
        merged_list[[name]] <- merge_lists(base, overlay)
      else {
        merged_list[[name]] <- NULL
        merged_list <- append(merged_list,
                              overlay_list[which(names(overlay_list) %in% name)])
      }
    }
    merged_list
  }
}

file_with_meta_ext <- function(file, meta_ext, ext = tools::file_ext(file)) {
  paste(tools::file_path_sans_ext(file),
        ".", meta_ext, ".", ext, sep = "")
}

