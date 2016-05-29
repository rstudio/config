context("errors")

test_that("config file with no defaults results in an error", {
  expect_error(config::get(file = "errors/nodefault.yml"))
})


test_that("reading a value with no default value results in an error", {
  expect_error(config::get(value = "shape",
                           config = "development",
                           file = "errors/nodefaultvalue.yml"))
})

