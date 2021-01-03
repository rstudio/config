# Structural change -------------------------------------------------------

# Example of a structural change (named to unnamed)
# Expectation:
# Entire 'host' element should be overwritten

test_that("Merging: structural change (named to unnamed)", {
  result <- get(
    file = test_path("merging/config_01.yml"),
    config = "prod"
  )

  expectation <- structure(
    list(
      host = list(
        list(id = "server_001", url = "https://prod-server-001.com",
          port = 8000L),
        list(id = "server_002", url = "https://prod-server-002.com",
          port = 8000L)
      ), hello = list(world = TRUE)),
    config = "prod",
    file = "path/to/config/file"
  )

  expect_equivalent(result, expectation)
})

# Unnamed list: simple ----------------------------------------------------

# Example of merging unnamed lists where UID information is contained in
# non-nested list
# Expectation:
# - server_001 should be overwritten
# - server_002 shold be kept
# - server_003 should be added

test_that("Merging: unnamed: simple", {
  result <- get(
    file = test_path("merging/config_02.yml"),
    config = "peak"
  )

  expectation <- structure(
    list(
      host = list(
        list(id = "server_001", url = "https://peak-server-001.com",
          port = 8000L),
        list(id = "server_002", url = "https://standard-server-002.com",
          port = 8000L),
        list(id = "server_003", url = "https://standard-server-003.com",
          port = 8000L)
      ),
      hello = list(world = TRUE)
    ),
    config = "peak",
    file = "path/to/config/file"
  )

  expect_equivalent(result, expectation)
})

# Unnamed list: nested ----------------------------------------------------

# Example of merging unnamed lists where UID information is contained in nested
# list
# Expectation:
# - server_001 should be overwritten
# - server_002 shold be kept
# - server_003 should be added

test_that("Merging: unnamed: nested", {
  result <- get(
    file = test_path("merging/config_03.yml"),
    config = "peak"
  )

  expectation <-structure(
    list(
      host = list(
        list(
          info = list(id = "server-001",
            description = "peak server-001"),
          url = "https://peak-server-001.com",
          port = 8000L
        ),
        list(
          info = list(id = "server-002", description = "standard server-002"),
          url = "https://standard-server-002.com",
          port = 8000L
        ),
        list(
          info = list(id = "server-003", description = "standard server-003"),
          url = "https://standard-server-003.com",
          port = 8000L
        )
      ),
      hello = list(world = TRUE)
    ),
    config = "peak",
    file = "path/to/config/file"
  )

  expect_equivalent(result, expectation)
})
