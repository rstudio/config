context("filter")

test_that("configurations can be filtered", {
  handle <- add_filter(function(config) {
    config$color <- "pink"
    config
  })
  on.exit(remove_filter(handle), add = TRUE)
  color <- config::get("color")
  expect_identical(color, "pink")
})

test_that("configurations filters can be removed", {
  handle <- add_filter(function(config) {
    config$color <- "pink"
    config
  })
  remove_filter(handle)
  color <- config::get("color")
  expect_identical(color, "red")
})
