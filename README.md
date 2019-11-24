
<!-- README.md is generated from README.Rmd. Please edit that file -->

# NaiveBayes

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/sidiwang/NaiveBayes.svg?branch=master)](https://travis-ci.org/sidiwang/NaiveBayes)
<!-- badges: end -->

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/sidiwang/NaiveBayes/branch/master/graph/badge.svg)](https://codecov.io/gh/sidiwang/NaiveBayes?branch=master)
<!-- badges: end -->

This is a homework assignment of BIOSTAT625 at the Univeristy of
Michigan, Ann Arbor.

The **NaiveBayes** package provides an efficient implementation of the
popular Naive Bayes classifier. This package is efficient, user friendly
and written in <span style="color:purple">base.R and Rcpp</span>. Like
many other classifier packages, the *general* function **NaiveBayes**
detects the class of each feature in the dataset. *Predict* function
uses a NaiveBayes model and a new data set to create the
classifications. This can either be the **raw** probabilities generated
by the NaiveBayes model or the **classes** themselves.

## Installation

You can download and install
<span style="color:purple">NaiveBayes</span> with:

``` r
library(devtools)
#> Loading required package: usethis
devtools::install_github("sidiwang/NaiveBayes", build_vignettes = T)
#> Skipping install of 'NaiveBayes' from a github remote, the SHA1 (adadfec4) has not changed since last install.
#>   Use `force = TRUE` to force installation
library(NaiveBayes)
```

The vignettes of this package contains very detailed infomation on
<span style="color:purple">“What is Naive Bayes”, “How to implement
Naive Bayes”, “The pros and cons of Naive Bayes”</span> and how
numerical underflow is handled during calculation. Various examples on
how to use this package, and a **performance comparison** against the
*naiveBayes* function in package **e1071** were also included. Given the
<span style="color:purple">NaiveBayes</span> function was partially
written in Rcpp and vectorized some calculations in matrix form, our
performance, in general, is better in efficiency and need less memory
allocation.

Please use this code to check the vignettes.

``` r
browseVignettes("NaiveBayes")
#> starting httpd help server ... done
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(NaiveBayes)
## load data, and define X and Y
data("HouseVotes84")
x = HouseVotes84[, -c(1,9:17)]
y = HouseVotes84[, 1]

# fit the model
mymodel = NaiveBayes::NaiveBayes(x, y)
# check output
mymodel
#> 
#> Naive Bayes Classifier for Discrete Predictors
#> 
#> Call:
#> NaiveBayes.default(x = x, y = y)
#> 
#> A-priori probabilities:
#> y
#>   democrat republican 
#>  0.5344828  0.4655172 
#> 
#> Predictors:
#> [1] "V1" "V2" "V3" "V4" "V5" "V6" "V7"
#> 
#> Conditional probabilities:
#>             V1
#> y                    n         y
#>   republican 0.7870370 0.2129630
#>   democrat   0.4112903 0.5887097
#> 
#>             V2
#> y                    n         y
#>   republican 0.5277778 0.4722222
#>   democrat   0.5483871 0.4516129
#> 
#>             V3
#> y                    n         y
#>   republican 0.8425926 0.1574074
#>   democrat   0.1451613 0.8548387
#> 
#>             V4
#> y                      n         y
#>   republican 0.009259259 0.9907407
#>   democrat   0.951612903 0.0483871
#> 
#>             V5
#> y                    n         y
#>   republican 0.0462963 0.9537037
#>   democrat   0.7983871 0.2016129
#> 
#>             V6
#> y                    n         y
#>   republican 0.1296296 0.8703704
#>   democrat   0.5564516 0.4435484
#> 
#>             V7
#> y                    n         y
#>   republican 0.7314815 0.2685185
#>   democrat   0.2338710 0.7661290
```

``` r
# prediction, here we predicted on the original training dataset for simplicity purpose, but you can always feed new dataset into the function.
prediction = predict(mymodel, x)
# check first 10 predictions
prediction[1:10]
#>  [1] democrat   republican democrat   democrat   democrat   democrat  
#>  [7] democrat   republican democrat   republican
#> Levels: democrat republican
```

## Limitations and reminders:

  - We are currently assuming Gaussian distribution for continuous
    variables, which is the typical assumption. In reality this may not
    always be the most appropriate choice. More distribution options can
    be easily added into the package, and will be added in the future.
  - Please correctly specify the data type of each column in your
    dataset before feeding it into the
    <span style="color:purple">NaiveBayes</span> function. As continuous
    variables and categorical variables should be treated differently
    according to the algorithm.
  - This is the **very first Rcpp / C++ program** written by the author,
    unaware of many Rcpp / C++ functions and coding rules, many
    redundant code may be included. Better efficiencies should be
    achieved in the future as the author become more experienced in
    coding Rcpp / C++.
