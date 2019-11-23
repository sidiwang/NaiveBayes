library(testthat)
library(NaiveBayes)
library(e1071)
library(mlbench)
library(datasets)


data(HouseVotes84, package = "mlbench")
HouseVotes84 <- na.omit(HouseVotes84)
x = HouseVotes84[,-1]
y = HouseVotes84[,1]
result = c(0.7870370, 0.4112903, 0.2129630, 0.5887097)
irisresult = c(5.006, 6.588, 5.936, 0.3524897, 0.6358796, 0.5161711)
predict = predict(naiveBayes(x,y),x)
irispredict = predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5])


test_that("Category / factoral variable classification", {
  expect_equal(c(NaiveBayes(x,y)$result[[1]]), result, tolerance = 1e-5)
})

test_that("continous variable classification", {
  expect_equal(c(NaiveBayes(iris[,-5], iris[,5])$result[[1]]), irisresult, tolerance = 1e-5)
})

test_that("prediction of Category / factoral variable classification", {
  expect_equal(predict(NaiveBayes(x,y),x), predict)
})

test_that("prediction of continous variable classification", {
  expect_equal(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5]), irispredict)
})
