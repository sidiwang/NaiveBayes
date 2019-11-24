library(testthat)
library(NaiveBayes)
library(e1071)
library(datasets)


irisresult = c(6.5880000, 5.0060000, 5.9360000, 0.6358796, 0.3524897, 0.5161711)
irispredict = predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5])
irispredict_raw = c(predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5], type = "raw")[,"versicolor"])

data(HouseVotes84)
colnames(HouseVotes84) = letters[1:17]
HVresult = c(0.7870370, 0.4112903,  0.2129630, 0.5887097)
HVpredict = predict(naiveBayes(HouseVotes84[,-1],HouseVotes84[,1]), HouseVotes84[1:10,-1])

test_that("continous variable classification", {
  expect_equal(c(NaiveBayes(iris[,-5], iris[,5])$result[[1]]), irisresult, tolerance = 1e-5)
})


test_that("prediction of continous variable classification", {
  expect_equal(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5]), irispredict)
})


test_that("prediction of continous variable classification", {
  expect_equal(c(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5], type = "raw")[,"versicolor"]), irispredict_raw, tolerance = 1e-5)
})

test_that("categorical variable classification", {
  expect_equal(c(NaiveBayes(HouseVotes84[,-1],HouseVotes84[,1])$result[[1]]), HVresult, tolerance = 1e-5)
})


#test_that("prediction of categorical variable classification", {
#  expect_equal(predict(NaiveBayes(HouseVotes84[,-1],HouseVotes84[,1]), HouseVotes84[1:10,-1]), HVpredict)
#})

