

test_that("with_config leaves env vars intret", {
  yaml <- '
  default:
    key: value
  '
  old_envs <- Sys.getenv()
  expect_equal(old_envs, Sys.getenv())

  expect_equal(
    with_config(yaml, config::get("key")),
    "value"
  )

  expect_equal(old_envs, Sys.getenv())

  config::get("color", config = "assigned") %>%
    expect_identical("black")
})
