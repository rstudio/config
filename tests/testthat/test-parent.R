context("parent")

test_that("config file is discovered in parent directory", {
  expect_identical(config::get("color", file = "parent/child/config.yml"),
                   "red")
})

test_that("use_parent prevents scanning of parent directories", {
  expect_error(config::get("color",
                           file = "parent/child/config.yml",
                           use_parent = FALSE),
               regexp = "not found in current working")

})

test_that("search for config file properly terminates", {
  expect_error(config::get("color", file = "parent/child/notexists.yml"),
               regexp = "not found in current working")
})


