# Create an example yaml file and write into tempdir()
# In real usage, this config file would be at your project root

yaml <- "
default:
  trials: 5
  dataset: 'data-sampled.csv'

production:
  trials: 30
  dataset: 'data.csv'
"

# write config.yaml into tempdir
cat(yaml, file = file.path(tempdir(), "config.yml"))

# Ensure that base::get() doesn't get masked, for tests on CRAN
get <- base::get

# only run examples if 'withr' is installed
if (requireNamespace("withr", quietly = TRUE)) {

  # These examples simulate the presence of a config file by reading from
  # tempdir().  In the real world you would typically not use withr::with_dir(),
  # but simply read the config file using config::get()

  withr::with_dir(tempdir(), {
    config::get()
  })

  withr::with_dir(tempdir(), {
    config::get("trials")
  })

}
