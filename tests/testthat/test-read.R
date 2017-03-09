context("read")

test_that("configuration file can be loaded", {
  config::get()
})

test_that("default configuration can be read", {
  color <- config::get("color")
  expect_identical(color, "red")
  shape <- config::get("shape")
  expect_identical(shape, "square")
})

test_that("configuration can be accessed as a list", {
  conf <- config::get()
  expect_identical(conf$color, "red")
  expect_identical(conf$shape, "square")
})

test_that("configurations override default", {
  conf <- config::get(config = "production")
  expect_identical(conf$color, "green")
  expect_identical(conf$shape, "circle")
})

test_that("configuration can be read from alternate file", {
  expect_identical(config::get("color", file = "config/conf.yml"), "red")
})

test_that("active configuration can be changed via an environment variable", {
  # restore previous state of environment after test
  previous_config <- Sys.getenv("R_CONFIG_ACTIVE", unset = NA);
  on.exit({
    if (!is.na(previous_config))
      Sys.setenv(R_CONFIG_ACTIVE = previous_config)
    else
      Sys.unsetenv("R_CONFIG_ACTIVE")
  }, add = TRUE)

  Sys.setenv(R_CONFIG_ACTIVE = "production")
  expect_identical(config::get("shape"), "circle")
})

test_that("R code is executed when reading configurations", {
  expect_identical(config::get("color", config = "dynamic"), "orange")
})

