library(e1071)
library(datasets)




# testing cases
test_that("continous variable classification", {
  irisresult = c(6.5880000, 5.0060000, 5.9360000, 0.6358796, 0.3524897, 0.5161711)
  expect_equal(c(NaiveBayes(iris[,-5], iris[,5])$result[[1]]), irisresult, tolerance = 1e-5)
})


test_that("1", {
  irispredict = predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5])
  expect_equal(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5]), irispredict)
})

test_that("1", {
  y = c("eight","one","nine")
  x = matrix(c("a","b","c","b","c","t","t","c","c","r","b","a"),3,4)
  simulation = c("eight","eight","eight")
  expect_equal(as.character(predict(NaiveBayes(x, y), x, eps = 100)), simulation)
})


test_that("3", {
  results = print(NaiveBayes(Species ~ ., data = iris)$apriori)
  expect_equal(print(NaiveBayes(Species ~ ., data = iris)$apriori), results)
})

test_that("prediction of continous variable classification", {
  irispredict_raw = c(predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5], type = "raw")[,"versicolor"])
  expect_equal(c(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5], type = "raw")[,"versicolor"]), irispredict_raw, tolerance = 1e-5)
})

test_that("categorical variable classification", {
  data(HouseVotes84)
  HVresult = c(0.7870370, 0.2129630)
  names(HVresult) = c("n","y")
  expect_equal(NaiveBayes(HouseVotes84[,-1],HouseVotes84[,1])$result[[1]]["republican",], HVresult, tolerance = 1e-5)
})

test_that("print", {
  y = c("eight","one","nine")
  x = matrix(c("a","b","c","b","c","t","t","c","c","r","b","a"),3,4)
  output_print = capture.output(print.NaiveBayes(NaiveBayes(x, y)))
  expect_equal(capture.output(print.NaiveBayes(NaiveBayes(x, y))), output_print)
})
