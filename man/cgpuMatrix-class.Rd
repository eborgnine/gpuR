% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-gpuMatrix.R
\docType{class}
\name{cgpuMatrix-class}
\alias{cgpuMatrix-class}
\title{cgpuMatrix Class}
\value{
If the gpuMatrix object is of type 'complex float', returns TRUE, if not, returns an error message.
}
\description{
An complex float type matrix in the S4 \code{gpuMatrix}
representation.
}
\section{Slots}{

 \describe{
     \item{\code{address}:}{Pointer to a complex float matrix.}
 }
}

\seealso{
\code{\link{gpuMatrix-class}}, 
\code{\link{igpuMatrix-class}},
\code{\link{dgpuMatrix-class}}
}
\author{
Charles Determan Jr.
}
