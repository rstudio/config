context("paths")

test_that("configuration can be read from alternate directory", {
  expect_identical(config::get("color", dir = "config"), "red")
})

test_that("configuration can be read from alternate file", {
  expect_identical(config::get("color", dir = "config", file = "conf.yml" ), "red")
})
