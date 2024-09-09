# Structural change -------------------------------------------------------

# Example of a structural change (named to unnamed)
# Expectation:
# Entire 'host' element should be overwritten

path_temp <- tempfile()

write("
default:
  host:
    url: https://dev-server.com
    port: 8000

prod:
  host:
    - id: server_001
      url: https://prod-server-001.com
      port: 8000
    - id: server_002
      url: https://prod-server-002.com
      port: 8000
  hello:
    world: true
", file = path_temp)

test_that("Merging: structural change (named to unnamed)", {
  result <- get(
    # file = test_path("merging/config_01.yml"),
    file = path_temp,
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

path_temp <- tempfile()

write("
default:
  host:
  - id: server_001
    url: https://standard-server-001.com
    port: 8000
  - id: server_002
    url: https://standard-server-002.com
    port: 8000

peak:
  host:
  - id: server_001
    url: https://peak-server-001.com
    port: 8000
  - id: server_003
    url: https://standard-server-003.com
    port: 8000
  hello:
    world: true
", file = path_temp)

test_that("Merging: unnamed: simple", {
  result <- get(
    # file = test_path("merging/config_02.yml"),
    file = path_temp,
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

path_temp <- tempfile()

write("
default:
  host:
    - info:
        id: server-001
        description: standard server-001
      url: https://standard-server-001.com
      port: 8000
    - info:
        id: server-002
        description: standard server-002
      url: https://standard-server-002.com
      port: 8000

peak:
  host:
    - info:
        id: server-001
        description: peak server-001
      url: https://peak-server-001.com
      port: 8000
    - info:
        id: server-003
        description: standard server-003
      url: https://standard-server-003.com
      port: 8000
  hello:
    world: true
", file = path_temp)

test_that("Merging: unnamed: nested", {
  result <- get(
    # file = test_path("merging/config_03.yml"),
    file = path_temp,
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
