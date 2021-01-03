

#' Merge two configurations.
#'
#' Merge one configuration into another recursively.
#'
#' @param base_config Configuration to merge values into
#'
#' @param merge_config Configuration to merge values from
#'
#' @return Configuration which includes the values from
#'  `merge_config` merged into `base_config`.
#'
#' @seealso [get()]
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
    
    # Handle merging of structural changes or unnamed lists
    merged_list <- if (all(is.null(names(overlay_list)))) {
      # This characteristic implies that additional processing steps need to
      # take place
      if (!all(is.null(names(merged_list)))) {
        # This implies a structural change from named list to unnamed list and
        # thus the new content should be returned all together
        overlay_list
      } else {
        # This is implies no structural break, but an unnamed list needs to be
        # merged with another unnamed list. As this is a non-trivial task with
        # lots of possible solutions, the current merging mechanism is a
        # simple solution that expects the first element of the sublists to
        # act as a unique identifier

        # Merge lists but with 'overlay_list' taking the lead
        merged_list <- append(overlay_list, merged_list)
        # Extract UIDs
        uids <- extract_uids(merged_list)
        # Drop duplicated UIDs and sort based on UIDs
        merged_list[!duplicated(uids)][order(unique(uids))]
      }
    } else {
      # Regular result if not special merging needed to take place
      merged_list
    }
    
    merged_list
  }
}

# Helper function for merging unnamed lists
extract_uids <- function(x) {
  index <- lapply(x, function(.x) {
    uid <- .x[[1]]
    if (!is.list(uid)) {
      uid
    } else {
      extract_uids(uid[[1]])
    }
  })

  unlist(index)
}
