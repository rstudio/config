# config 0.3.2

New features:

- Better handling of R expressions in the `config.yml`.  In particular, you can 
now refer to other configuration values in the R expression.

- Check if package is attached and throw message to use `config::ge()` instead.

- New function `with_config()` that might be useful for testing and in vignettes.

- Allow using a string for `.active_config` in `with_config()`


Documentation:

- New vignettes, in particular using `config` with Posit Connect.
- Better documentation to not attach the package and use `config::get()` instead.


# config 0.3.1 (2020-12-15)

* Bug fix: evaluate expressions only for the active config (not all configs). In
previous versions of `config`, all expressions in the `yml` file were evaluated,
regardless whether these expressions were used in the active config.  In this
version, the appropriate config is selected, and only then are the expressions
evaluated.  Fixes #20

# config 0.3.0 (2018-03-27)

* Improved handling of expressions

* Bug fixes

# config 0.2.0 (2016-08-02)

* Add `merge` function to merge one configuration into another.


# config 0.1.0 (2016-06-08)

Initial release to CRAN
