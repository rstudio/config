test_that("configurations inherit from default", {
  conf <- config::get(config = "development")
  conf_json <- jsonlite::toJSON(conf)
  expect_type(conf_json, "character")
  expect_equal(
    as.character(conf_json),
    '{"color":["red"],"shape":["triangle"]}',
    ignore_attr = TRUE)
})
