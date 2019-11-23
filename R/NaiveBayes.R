#' NaiveBayes
#'
#' This NaiveBayes package provides an efficient implementation of the very popular Naive
#' Bayes classifier, which assumes independence between the feature variables. The core
#' classification function was written in Rcpp. Gaussian distribution is used with numerical
#' variables. Please use 'NaiveBayes(...)' to fit model, and use 'predict()' to obtain its
#' corresponding predictions.
#'
#' The general function \bold{\code{NaiveBayes()}} detects the class of each feature in the
#' dataset and assumes possibly different distribution for each feature.
#'
#' @import Rcpp stats
#' @importFrom Rcpp evalCpp
#' @importFrom Rcpp sourceCpp
#'
#' @param x matrix or dataframe with categorical (character/factor/logical) or metric (numeric) predictors
#' , with correctly specified data types in each column.
#' @param y class vector (character/factor/logical)
#' @param laplace value used for Laplace smoothing (additive smoothing). Defaults to 0 (no
#' Laplace smoothing)
#' @return An object of class "NaiveBayes".
#'
#' @details 1. Numeric (metric) predictors are handled by assuming that they follow Gaussian distribution,
#' given the class label; Missing values are not included into constructing tables. Logical variables
#' are treated as categorical (binary) variables.
#'
#' @note The class "numeric" contains "double" (double precision floating point numbers) and "integer".
#' Prior the model fittng the classes of columns in the data.frame "data" can be easily checked via:
#' \itemize{
#' \item \code{sapply(data, class)}
#' \item \code{sapply(data, is.numeric)}
#' \item \code{sapply(data, is.double)}
#' \item \code{sapply(data, is.integer)}
#' }
#'
#' @seealso fda
#'

#' @examples
#' ## Example with metric predictors:
#' data(iris)
#' m <- NaiveBayes(iris[,-5], iris[,5])
#' m
#' table(predict(m, iris), iris[,5])
#'

#' @useDynLib NaiveBayes
#'


#' @rdname NaiveBayes
#' @export NaiveBayes
NaiveBayes = function(x, ...)
  UseMethod("NaiveBayes", x)

#' @rdname NaiveBayes
#' @export
NaiveBayes.default = function(x, y, laplace = 0, ...){
  call = match.call()
  x = as.data.frame(x)
  n_var = ncol(x)
  Name_y = deparse(substitute(y))
  y = as.character(y)
  laplace = laplace

  # format output
  apriori = table(y)
  results = mean_sd(x, y, laplace)

  for (i in 1:length(results)){
    names(dimnames(results[[i]])) = c(Name_y, colnames(x)[i])
  }
  names(dimnames(apriori)) = Name_y

  structure(list(apriori = apriori / sum(apriori),
                 results = results,
                 levels = if (is.logical(y)) c(FALSE, TRUE) else levels(y),
                 predictors = colnames(x),
                 call   = call
  ),
  class = "NaiveBayes"
  )
}

#' @rdname  NaiveBayes
#' @export
# for formula input
NaiveBayes.formula = function(formula, data, laplace = 0, ...) {
  call = match.call()
  fm = match.call(expand.dots = FALSE)
  fm$... = NULL
  fm$laplace = NULL
  fm[[1L]] = quote(stats::model.frame)
  fm = eval(fm, parent.frame())
  tms = attr(fm, "terms")
  Y = model.extract(fm, "response")
  X = fm[,-attr(tms, "response"), drop = FALSE]

  return(NaiveBayes(X, Y, laplace = laplace, ...))
}


#' @rdname NaiveBayes
#' @export
# output format for model fitting
print.NaiveBayes = function(x, ...) {
  cat("\nNaive Bayes Classifier for Discrete Predictors\n\n")
  cat("Call:\n")
  print(x$call)
  cat("\nA-priori probabilities:\n")
  print(x$apriori)
  cat("\nPredictors:\n")
  print(x$predictors)
  cat("\nConditional probabilities:\n")
  for (i in x$results) {print(i); cat("\n")}
}


#' @rdname  NaiveBayes
#' @export
predict.NaiveBayes <- function(object, newdata, type = c("class", "raw"), threshold = 0.001, eps = 0, ...) {
  type = match.arg(type)
  newdata = as.data.frame(newdata)
  neworder = match(object$predictors, colnames(newdata))
  probs = matrix(0, length(object$apriori), nrow(newdata))

  # generate probability of each observation given each level of y
  for (j in 1:nrow(newdata)){
    probs[ , j] = rowSums(log(sapply(neworder, function(index){
      if (is.numeric(newdata[j,index])){
        oneresult = object$results[[index]]
        oneresult[, 2][oneresult[, 2] <= eps] = threshold
        return(stats::dnorm(newdata[j,index], oneresult[, 1], oneresult[, 2]))
      } else {
        prob = object$results[[index]][, newdata[j, index]]
        prob[prob <= eps] = threshold
        return(prob)
      }})))
  }

  # calculate the probability of each observation being categorized under different levels of y
  probs = t(exp(probs))
  apriori = object$apriori
  for (i in 1:length(apriori)) {
    probs[, i] = probs[, i] * apriori[i]
  }
  sums = rowSums(probs)
  sums[sums == 0] = 1
  probs = probs/sums
  colnames(probs) = rownames(object$results[[1]])

  # output "class" or "raw"
  if (type == "class") {
    class = as.factor(rownames(object$results[[1]])[max.col(probs, ties.method = "first")])
    return(class)
  } else {
    return(probs)
  }
}










