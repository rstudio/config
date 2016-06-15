

#' Merge two configurations
#'
#' Merge one configuration into another recursively.
#'
#' @param base_config Configuration to merge values into
#' @param merge_config Configuration to merge values from
#'
#' @return Configuration which includes the values from
#'  \code{merge_config} merged into \code{base_config}.
#'
#' @export
merge <- function(base_config, merge_config) {
  merge_lists(base_config, merge_config, recursive = TRUE)
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

