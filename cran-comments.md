This release of `config` fixes a problem with the package help documentation, as requested by Kurt Hornik.

## Reverse dependencies

Unfortunately this introduces two small problems with reverse dependencies.

I checked 58 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

* 56 packages have no problems
* 2 packages fail with conflicts in namespace
 
These failures occur because of incorrect imports of the `config` package.  I have written to both package authors and created a pull request on their repo. I also requested that they submit a new version to CRAN.

* `cognitoR`
  - https://github.com/chi2labs/cognitoR
  
* `ProPublicaR` 
  - https://github.com/dietrichson/ProPublicaR
  
