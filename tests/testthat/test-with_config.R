

test_that("with_config leaves env vars intret", {
  yaml <- '
  default:
    key: value
    eval_1: !expr Sys.getenv("extra_1")
    eval_2: !expr Sys.getenv("extra_2")
  '
  old_envs <- Sys.getenv()
  expect_equal(old_envs, Sys.getenv())

  expect_equal(
    with_config(yaml, config::get("key")),
    "value"
  )

  expect_equal(
    with_config(yaml, config::get("eval_1"), .extra_env_vars = c(extra_1 = "extra_value")),
    "extra_value"
  )

  expect_equal(
    with_config(yaml, config::get("eval_2"),
                .extra_env_vars = c(c(extra_1 = "extra_value"), c(extra_2 = "extra_value_2"))
                ),
    "extra_value_2"
  )

  expect_equal(old_envs, Sys.getenv())

  config::get("color", config = "assigned") %>%
    expect_identical("black")
})
