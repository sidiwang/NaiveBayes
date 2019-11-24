library(e1071)
library(datasets)


# testing cases
test_that("fit continuous variables", {
  irisresult = c(5.0060000, 0.3524897)
  expect_equal(c(NaiveBayes(iris[,-5], iris[,5])$result[[1]]["setosa",]), irisresult, tolerance = 1e-5)
})


test_that("predict based on continuous variables, return 'class'", {
  irispredict = predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5])
  expect_equal(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5]), irispredict)
})


test_that("prediction based on continuous varialbes, return 'raw'", {
  irispredict_raw = c(predict(naiveBayes(iris[,-5], iris[,5]), iris[,-5], type = "raw")[,"versicolor"])
  expect_equal(c(predict(NaiveBayes(iris[,-5], iris[,5]), iris[,-5], type = "raw")[,"versicolor"]), irispredict_raw, tolerance = 1e-5)
})



test_that("fit categorical variables", {
  data(HouseVotes84)
  HVresult = c(0.7870370, 0.2129630)
  names(HVresult) = c("n","y")
  expect_equal(NaiveBayes(HouseVotes84[,-1],HouseVotes84[,1])$result[[1]]["republican",], HVresult, tolerance = 1e-5)
})

test_that("predict based on categorical varialbes, with eps", {
  simulation = c("democrat")
  expect_equal(as.character(predict(NaiveBayes(HouseVotes84[,-1],HouseVotes84[,1]), HouseVotes84[1,-1])), simulation)
})


test_that("testing formula input format", {
  results = print(NaiveBayes(Species ~ ., data = iris)$apriori)
  expect_equal(print(NaiveBayes(Species ~ ., data = iris)$apriori), results)
})


test_that("test print function", {
  y = c("eight","one","nine")
  x = matrix(c("a","b","c","b","c","t","t","c","c","r","b","a"),3,4)
  output_print = c("")
  expect_equal(capture.output(print.NaiveBayes(NaiveBayes(x, y)))[1], output_print)
})
