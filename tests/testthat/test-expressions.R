
test_that("expressions can use previously assigned parameters", {
  config::get("new_color", config = "assigned") %>%
    expect_warning(".*Attempt to assign nested list value from expression..*") %>%
    expect_identical("red-orange")
})

test_that("expressions can't use previously other expressions", {
  config::get("new_nested_not_found", config = "assigned") %>%
    expect_warning(".*Attempt to assign nested list value from expression..*") %>%
    expect_null()
})


