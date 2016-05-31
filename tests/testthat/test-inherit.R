context("inherit")

test_that("configurations inherit from default", {
  conf <- config::get(config = "development")
  expect_identical(conf$color, "red")
  expect_identical(conf$shape, "triangle")
})

test_that("configurations can inherit from other configurations", {
  conf <- config::get(config = "test")
  expect_identical(conf$shape, "triangle")
})

test_that("configuration inheriting from itself is an error", {
  expect_error(config::get(config = "test", file = "config-inheritself.yml"),
               regexp = "inherits from itself")
})

