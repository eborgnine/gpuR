% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generics.R, R/methods-vclMatrix.R, R/methods.R
\name{distance}
\alias{distance}
\alias{dist,vclMatrix-method}
\alias{dist,vclMatrix}
\alias{distance,vclMatrix,vclMatrix-method}
\alias{distance,vclMatrix}
\alias{dist,gpuMatrix-method}
\alias{dist,gpuMatrix}
\alias{distance,gpuMatrix,gpuMatrix-method}
\alias{distance,gpuMatrix}
\title{GPU Distance Matrix Computations}
\usage{
distance(x, y, method = "euclidean")

\S4method{dist}{vclMatrix}(x, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

\S4method{distance}{vclMatrix,vclMatrix}(x, y, method = "euclidean")

\S4method{dist}{gpuMatrix}(x, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)

\S4method{distance}{gpuMatrix,gpuMatrix}(x, y, method = "euclidean")
}
\arguments{
\item{x}{A gpuMatrix or vclMatrix object}

\item{y}{A gpuMatrix or vclMatrix object}

\item{method}{the distance measure to be used. This must be one of
"euclidean" or "sqEuclidean".}

\item{diag}{logical value indicating whether the diagonal of the distance 
matrix should be printed}

\item{upper}{logical value indicating whether the upper triangle of the 
distance matrix}

\item{p}{The power of the Minkowski distance (not currently used)}
}
\value{
a \code{gpuMatrix}/\code{vclMatrix} containing the pairwise distances 
between rows of `x` and `y`, based on the specified method.
}
\description{
This function computes and returns the distance matrix 
computed by using the specified distance measure to compute the distances 
between the rows of a data matrix.
}
