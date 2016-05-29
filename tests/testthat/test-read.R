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

test_that("configurations inherit from default", {
  conf <- config::get(config = "development")
  expect_identical(conf$color, "red")
  expect_identical(conf$shape, "triangle")
})

test_that("local config overrides base config", {
  conf <- config::get(dir = "config/local")
  expect_identical(conf$shape, "rectangle")
})

