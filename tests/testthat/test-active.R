
test_that("multiple active configurations are applied", {
  config <- config::get(config = c("production", "east"),
                        file = "config-multiple.yml")
  expect_identical(config$color, "green")
  expect_identical(config$shape, "hexagon")
})
