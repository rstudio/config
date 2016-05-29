context("errors")

test_that("config file with no defaults results in an error", {
  expect_error(config::get(dir = "errors", file = "nodefault.yml"))
})


test_that("reading a value with no default value results in an error", {
  expect_error(config::get(value = "shape",
                           dir = "errors",
                           file = "nodefaultvalue.yml",
                           config = "development"))
})

test_that("reading a non-existent config results in an error", {
  expect_error(config::get(config = "nil"))
})
