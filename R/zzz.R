.onAttach <- function(...) {
  msg <- paste(
    "Do not use `library(config)` to attach the config package.",
    "Use `config::get()` directly.",
    "Attaching the config package can lead to namespace conflicts.",
    sep = "\n"
  )
  if (!is_loading_for_tests()) {
    packageStartupMessage(msg, appendLF = TRUE)
  }
}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}

is_loading_for_tests <- function() {
  identical(Sys.getenv("DEVTOOLS_LOAD"), "config")
}
