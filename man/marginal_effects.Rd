% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/marginal_effects.R,
%   R/marginal_effects_default.R, R/marginal_effects_glm.R,
%   R/marginal_effects_lm.R, R/marginal_effects_loess.R,
%   R/marginal_effects_merMod.R, R/marginal_effects_nnet.R,
%   R/marginal_effects_polr.R
\name{marginal_effects}
\alias{marginal_effects}
\alias{marginal_effects.margins}
\alias{marginal_effects.default}
\alias{marginal_effects.glm}
\alias{marginal_effects.lm}
\alias{marginal_effects.loess}
\alias{marginal_effects.merMod}
\alias{marginal_effects.lmerMod}
\alias{marginal_effects.nnet}
\alias{marginal_effects.polr}
\title{Differentiate a Model Object with Respect to All (or Specified) Variables}
\usage{
marginal_effects(model, data, variables = NULL, ...)

\method{marginal_effects}{margins}(model, data, variables = NULL, ...)

\method{marginal_effects}{default}(model, data = find_data(model,
  parent.frame()), variables = NULL, type = c("response", "link"),
  eps = 1e-07, as.data.frame = TRUE, varslist = NULL, ...)

\method{marginal_effects}{glm}(model, data = find_data(model, parent.frame()),
  variables = NULL, type = c("response", "link"), eps = 1e-07,
  as.data.frame = TRUE, varslist = NULL, ...)

\method{marginal_effects}{lm}(model, data = find_data(model, parent.frame()),
  variables = NULL, type = c("response", "link"), eps = 1e-07,
  as.data.frame = TRUE, varslist = NULL, ...)

\method{marginal_effects}{loess}(model, data = find_data(model,
  parent.frame()), variables = NULL, type = c("response", "link"),
  eps = 1e-07, as.data.frame = TRUE, varslist = NULL, ...)

\method{marginal_effects}{merMod}(model, data = find_data(model),
  variables = NULL, type = c("response", "link"), eps = 1e-07,
  as.data.frame = TRUE, varslist = NULL, ...)

\method{marginal_effects}{lmerMod}(model, data = find_data(model),
  variables = NULL, type = c("response", "link"), eps = 1e-07,
  as.data.frame = TRUE, varslist = NULL, ...)

\method{marginal_effects}{nnet}(model, data = find_data(model,
  parent.frame()), variables = NULL, eps = 1e-07, varslist = NULL,
  as.data.frame = TRUE, ...)

\method{marginal_effects}{polr}(model, data = find_data(model,
  parent.frame()), variables = NULL, eps = 1e-07, varslist = NULL,
  as.data.frame = TRUE, ...)
}
\arguments{
\item{model}{A model object, perhaps returned by \code{\link[stats]{lm}} or \code{\link[stats]{glm}}}

\item{data}{A data.frame over which to calculate marginal effects. This is optional, but may be required when the underlying modelling function sets \code{model = FALSE}.}

\item{variables}{A character vector with the names of variables for which to compute the marginal effects. The default (\code{NULL}) returns marginal effects for all variables.}

\item{\dots}{Arguments passed to methods, and onward to \code{\link{dydx}} methods and possibly further to \code{\link[prediction]{prediction}} methods. This can be useful, for example, for setting \code{type} (predicted value type), \code{eps} (precision), or \code{category} (category for multi-category outcome models), etc.}

\item{type}{A character string indicating the type of marginal effects to estimate. Mostly relevant for non-linear models, where the reasonable options are \dQuote{response} (the default) or \dQuote{link} (i.e., on the scale of the linear predictor in a GLM).}

\item{eps}{A numeric value specifying the \dQuote{step} to use when calculating numerical derivatives. By default this is the smallest floating point value that can be represented on the present architecture.}

\item{as.data.frame}{A logical indicating whether to return a data frame (the default) or a matrix.}

\item{varslist}{A list structure used internally by \code{\link{margins}}. Users should not set this.}
}
\value{
An data frame with number of rows equal to \code{nrow(data)}, where each row is an observation and each column is the marginal effect of a variable used in the model formula.
}
\description{
Extract marginal effects from a model object, conditional on data, using \code{\link{dydx}}.
}
\details{
Users likely want to use the fully featured \code{\link{margins}} function rather than \code{marginal_effects}, which merely performs estimation of the marginal effects but simply returns a data frame. \code{\link{margins}}, by contrast, does some convenient packaging around these results and supports additional functionality, like variance estimation and counterfactual estimation procedures. The methods for this function provide lower-level functionality that extracts unit-specific marginal effects from an estimated model with respect to \emph{all} variables specified in \code{data} (or the subset specified in \code{variables}) and returns a data frame. See \code{\link{dydx}} for computational details. Note that for factor and logical class variables, discrete changes in the outcome are reported rather than instantaneous marginal effects.

Methods are currently implemented for the following object classes:
\itemize{
  \item \dQuote{betareg}, see \code{\link[betareg]{betareg}}
  \item \dQuote{glm}, see \code{\link[stats]{glm}}, \code{\link[MASS]{glm.nb}}
  \item \dQuote{ivreg}, see \code{\link[AER]{ivreg}}
  \item \dQuote{lm}, see \code{\link[stats]{lm}}
  \item \dQuote{loess}, see \code{\link[stats]{loess}}
  \item \dQuote{merMod}, see \code{\link[lme4]{lmer}}, \code{\link[lme4]{glmer}}
  \item \dQuote{nnet}, see \code{\link[nnet]{nnet}}
  \item \dQuote{polr}, see \code{\link[MASS]{polr}}
  \item \dQuote{svyglm}, see \code{\link[survey]{svyglm}}
}

A method is also provided for the object classes \dQuote{margins} to return a simplified data frame from complete \dQuote{margins} objects.
}
\examples{
require("datasets")
x <- lm(mpg ~ cyl * hp + wt, data = mtcars)
marginal_effects(x)

# factor variables report discrete differences
x <- lm(mpg ~ factor(cyl) * factor(am), data = mtcars)
marginal_effects(x)

# get just marginal effects from "margins" object
require('datasets')
m <- margins(lm(mpg ~ hp, data = mtcars[1:10,]))
marginal_effects(m)
marginal_effects(m)

# multi-category outcome
if (requireNamespace("nnet")) {
  data("iris3", package = "datasets")
  ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                    species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))
  m <- nnet::nnet(species ~ ., data = ird, size = 2, rang = 0.1,
                  decay = 5e-4, maxit = 200, trace = FALSE)
  marginal_effects(m) # default
  marginal_effects(m, category = "v") # explicit category
}

}
\seealso{
\code{\link{dydx}}, \code{\link{margins}}
}
\keyword{models}
