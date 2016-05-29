
#' @export
get <- function(value = NULL,
                dir = ".",
                file = "config.yml",
                config = Sys.getenv("R_CONFIG_NAME", "default")) {

  # load the yaml
  config_file <- file.path(dir, file)
  config_yaml <- yaml::yaml.load_file(config_file)

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
  if (is.null(active_config))
    stop("Configuration '", config, "' not found in ", file)

  # if it isn't the default config then merge it with the default
  if (!identical(config, "default"))
    active_config <- merge_lists(default_config, active_config)

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
