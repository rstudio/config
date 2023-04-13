
yaml <- '
default:
  db_name: dbase
  databases:
    db1: !expr paste0(db_name, "/one")
    db2: !expr paste0(db_name, "/two")

staging:
  staging_postfix: _staging
  db_name: dbase
  databases:
    db1: !expr paste0(db_name, staging_postfix, "/one")
    db2: !expr paste0(db_name, staging_postfix, "/two")
'

# Ensure that base::get() doesn't get masked, for tests on CRAN
get <- base::get

with_config(yaml, config::get() )
with_config(yaml, config::get("databases", config = "default") )
with_config(yaml, config::get("databases", config = "staging") )

config_file <- system.file("tests/testthat/config.yml", package = "config")
if (file.exists(config_file)) {
  with_config(config_file, config::get())
}
