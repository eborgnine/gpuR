% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\docType{methods}
\name{colSums,gpuMatrix-method}
\alias{colSums,gpuMatrix-method}
\alias{colSums,gpuMatrix}
\alias{rowSums,gpuMatrix}
\alias{rowSums,gpuMatrix-method}
\alias{colMeans,gpuMatrix-method}
\alias{rowMeans,gpuMatrix-method}
\title{Row and Column Sums and Means of gpuMatrix}
\usage{
\S4method{colSums}{gpuMatrix}(x)

\S4method{rowSums}{gpuMatrix}(x)

\S4method{colMeans}{gpuMatrix}(x)

\S4method{rowMeans}{gpuMatrix}(x)
}
\arguments{
\item{x}{A gpuMatrix object}
}
\value{
A gpuvector containing the sum of each column in the gpuMatrix.

A gpuvector containing the sum of each row in the gpuMatrix.

A gpuvector containing the mean of each column in the gpuMatrix.

A gpuvector containing the mean of each row in the gpuMatrix.
}
\description{
Row and column sums and of gpuMatrix objects
}
\author{
Charles Determan Jr.
}
