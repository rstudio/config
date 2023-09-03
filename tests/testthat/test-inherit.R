
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

test_that("configurations can inherit from multiple other configurations", {
  config <- config::get(config = "west", file = "config-multiple.yml")
  expect_identical(config$shape, "hexagon")
  expect_identical(config$log, TRUE)
})

test_that("inheritance can be an expression", {
  expect_equal(
    config::get("letter", file = "config-inherits-expr.yml"),
    "a"
  )
  withr::with_envvar(c(CONFIG = "b"), {
    expect_equal(
      config::get("letter", config = "b", file = "config-inherits-expr.yml"),
      "b"
    )
  })
  withr::with_envvar(c(CONFIG = "b"), {
    expect_equal(
      config::get("letter", config = "shinyapps", file = "config-inherits-expr.yml"),
      "b"
    )
  })
  withr::with_envvar(c(CONFIG = "b"), {
    expect_equal(
      config::get("letter", config = "noinherit", file = "config-inherits-expr.yml"),
      "c"
    )
  })
})
