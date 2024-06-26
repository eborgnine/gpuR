% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods-gpuVector.R, R/methods-vclMatrix.R,
%   R/methods-vclVector.R, R/methods.R
\docType{methods}
\name{\%*\%,gpuVector,gpuVector-method}
\alias{\%*\%,gpuVector,gpuVector-method}
\alias{\%*\%,gpuVector,gpuMatrix-method}
\alias{\%*\%,vclMatrix,vclMatrix-method}
\alias{\%*\%,vclMatrix,vclVector-method}
\alias{\%*\%,vclMatrix,matrix-method}
\alias{\%*\%,matrix,vclMatrix-method}
\alias{\%*\%,vclVector,vclVector-method}
\alias{\%*\%,vclVector,vclMatrix-method}
\alias{\%*\%,gpuMatrix,gpuMatrix-method}
\alias{\%*\%,gpuMatrix,gpuVector-method}
\alias{\%*\%,gpuMatrix,matrix-method}
\alias{\%*\%,matrix,gpuMatrix-method}
\title{Methods for gpu/vcl Vector}
\usage{
\S4method{\%*\%}{gpuVector,gpuVector}(x, y)

\S4method{\%*\%}{gpuVector,gpuMatrix}(x, y)

\S4method{\%*\%}{vclMatrix,vclMatrix}(x, y)

\S4method{\%*\%}{vclMatrix,vclVector}(x, y)

\S4method{\%*\%}{vclMatrix,matrix}(x, y)

\S4method{\%*\%}{matrix,vclMatrix}(x, y)

\S4method{\%*\%}{vclVector,vclVector}(x, y)

\S4method{\%*\%}{vclVector,vclMatrix}(x, y)

\S4method{\%*\%}{gpuMatrix,gpuMatrix}(x, y)

\S4method{\%*\%}{gpuMatrix,gpuVector}(x, y)

\S4method{\%*\%}{gpuMatrix,matrix}(x, y)

\S4method{\%*\%}{matrix,gpuMatrix}(x, y)
}
\arguments{
\item{x}{A gpuR object}

\item{y}{A gpuR object}
}
\value{
The inner product of the two \code{gpuVector} objects \code{x} and \code{y}.

The result of matrix-vector multiplication between the \code{gpuMatrix} \code{y}
and the \code{gpuVector} \code{x}.

The result of multiplying the \code{vclMatrix} `x` and the \code{vclVector} `y`.

A \code{vclMatrix} object, the result of multiplying 
the \code{vclMatrix} `x` and the regular R matrix `y`.

A \code{vclMatrix} object, the result of multiplying the regular 
R matrix x and the \code{vclMatrix} y.

A \code{gpuMatrix} object which is the result of multiplying 
the two \code{gpuMatrix} objects `x` and `y`.
}
\description{
Multiply two gpuR objects, if they are conformable.  If both
are vectors of the same length, it will return the inner product (as a matrix).
}
\author{
Charles Determan Jr.
}
