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
