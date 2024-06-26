% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-gpuMatrix.R
\docType{class}
\name{gpuMatrix-class}
\alias{gpuMatrix-class}
\title{gpuMatrix Class}
\value{
An object of class 'gpuMatrix' with the specified slots.
}
\description{
This is the 'mother' class for all
gpuMatrix objects.  It is essentially a wrapper for
a basic R matrix (possibly to be improved).  All other 
gpuMatrix classes inherit from this class but 
there are no current circumstances where this class 
is used directly.

There are multiple child classes that correspond
to the particular data type contained.  These include
\code{igpuMatrix}, \code{fgpuMatrix}, and 
\code{dgpuMatrix} corresponding to integer, float, and
double data types respectively.
}
\note{
R does not contain a native float type.  As such,
the matrix data within a \code{\link{fgpuMatrix-class}} 
will be represented as double but downcast when any 
gpuMatrix methods are used.

May also remove the type slot
}
\section{Slots}{

 Common to all gpuMatrix objects in the package
 \describe{
     \item{\code{address}:}{Pointer to data matrix}
     \item{\code{.context_index}:}{Integer index of OpenCL contexts}
     \item{\code{.platform_index}:}{Integer index of OpenCL platforms}
     \item{\code{.platform}:}{Name of OpenCL platform}
     \item{\code{.device_index}:}{Integer index of active device}
     \item{\code{.device}:}{Name of active device}
 }
}

\seealso{
\code{\link{igpuMatrix-class}}, 
\code{\link{fgpuMatrix-class}},
\code{\link{dgpuMatrix-class}}
}
\author{
Charles Determan Jr.
}
