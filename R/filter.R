

#' Specify filters for configuration values
#'
#' Provide a filter that is called from the [get()] method with the resolved
#' configuration. The filter can modify the configuration and return an
#' alternate configuration.
#'
#' @param filter Filter function
#' @param handle Handle to previously installed filter function.
#'
#' @details The `add_filter()` function returns a handle which can be
#'   subsequently passed to `remove_filter()` to remove the filter.
#'
#' @name filters
#' @export
add_filter <- function(filter) {
  handle <- uuid::UUIDgenerate()
  .globals$filters[[handle]] <- filter
  handle
}


#' @rdname filters
#' @export
remove_filter <- function(handle) {
  .globals$filters[[handle]] <- NULL
}

