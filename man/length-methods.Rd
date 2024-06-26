% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods-gpuVector.R, R/methods-vclMatrix.R,
%   R/methods-vclVector.R, R/methods.R
\docType{methods}
\name{length,gpuVector-method}
\alias{length,gpuVector-method}
\alias{length,vclMatrix-method}
\alias{length-vclMatrix}
\alias{length,vclVector-method}
\alias{length,gpuMatrix-method}
\alias{length-gpuMatrix}
\title{gpuMatrix/vclMatrix length method}
\usage{
\S4method{length}{gpuVector}(x)

\S4method{length}{vclMatrix}(x)

\S4method{length}{vclVector}(x)

\S4method{length}{gpuMatrix}(x)
}
\arguments{
\item{x}{A gpuMatrix/vclMatrix object}
}
\value{
Length of the gpuVector object \code{x}.

The total number of elements in the vclMatrix object `x`.

The length of the vclVector based on its data type.

A numeric value
}
\description{
Retrieve number of elements in object
}
\author{
Charles Determan Jr.
}
