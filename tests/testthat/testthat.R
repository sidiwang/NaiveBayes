library(testthat)
library(NaiveBayes)
library(e1071)
library(datasets)



irisresult = c(5.006, 6.588, 5.936, 0.3524897, 0.6358796, 0.5161711)

irispredict = predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5])




test_that("continous variable classification", {
  expect_equal(c(NaiveBayes(iris[,-5], iris[,5])$result[[1]]), irisresult, tolerance = 1e-5)
})



test_that("prediction of continous variable classification", {
  expect_equal(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5]), irispredict)
})
