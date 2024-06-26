#' @import methods
#' @importFrom utils file_test


#' @export
as.matrix.gpuMatrix <- function(x, ...){
    out <- x[]
    return(out)
}


#' @title Matrix Multiplication
#' @description Multiply two gpuR objects, if they are conformable.  If both
#' are vectors of the same length, it will return the inner product (as a matrix).
#' @param x A gpuR object
#' @param y A gpuR object
#' @return A \code{gpuMatrix} object which is the result of multiplying 
#' the two \code{gpuMatrix} objects `x` and `y`.
#' @docType methods
#' @rdname grapes-times-grapes-methods
#' @author Charles Determan Jr.
#' @export
setMethod("%*%", signature(x="gpuMatrix", y = "gpuMatrix"),
          function(x,y)
          {
              if( dim(x)[2] != dim(y)[1]){
                  stop("Non-conformant matrices")
              }
              return(gpu_Mat_mult(x, y))
          },
          valueClass = "gpuMatrix"
)


#' @rdname grapes-times-grapes-methods
#' @export
setMethod("%*%", signature(x="gpuMatrix", y = "gpuVector"),
          function(x,y)
          {
              if( ncol(x) != length(y)){
                  stop("Non-conformable arguments")
              }
              return(vclGEMV(x, y))
          },
          valueClass = "gpuVector"
)



#' @rdname grapes-times-grapes-methods
#' @export
setMethod("%*%", signature(x="gpuMatrix", y = "matrix"),
          function(x,y)
          {
              if( dim(x)[2] != dim(y)[1]){
                  stop("Non-conformant matrices")
              }
              y <- gpuMatrix(y, type = typeof(x), ctx_id = x@.context_index)
              return(gpu_Mat_mult(x, y))
          },
          valueClass = "gpuMatrix"
)



#' @rdname grapes-times-grapes-methods
#' @export
setMethod("%*%", signature(x="matrix", y = "gpuMatrix"),
          function(x,y)
          {
              if( dim(x)[2] != dim(y)[1]){
                  stop("Non-conformant matrices")
              }
              x <- gpuMatrix(x, type = typeof(y), ctx_id = y@.context_index)
              return(gpu_Mat_mult(x, y))
          },
          valueClass = "gpuMatrix"
)


#' @title Arith methods
#' @description Methods for the base Arith methods \link[methods]{S4groupGeneric}
#' @param e1 A gpuR object
#' @param e2 A gpuR object
#' @return A gpuR object
#' @docType methods
#' @rdname Arith-methods
#' @aliases Arith-gpuR-method
#' @author Charles Determan Jr.
#' @export
setMethod("Arith", c(e1="gpuMatrix", e2="gpuMatrix"),
          function(e1, e2)
          {
              op = .Generic[[1]]
              switch(op,
                     `+` = gpu_Mat_axpy(1, e1, e2),
                     `-` = gpu_Mat_axpy(-1, e2, e1),
                     `*` = gpuMatElemMult(e1, e2),
                     `/` = gpuMatElemDiv(e1, e2),
                     `^` = gpuMatElemPow(e1, e2),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)


#' @rdname Arith-methods
#' @export
setMethod("Arith", c(e1="gpuMatrix", e2="matrix"),
          function(e1, e2)
          {
              
              e2 <- gpuMatrix(e2, type = typeof(e1), ctx_id = e1@.context_index)
              
              op = .Generic[[1]]
              
              switch(op,
                     `+` = gpu_Mat_axpy(1, e1, e2),
                     `-` = gpu_Mat_axpy(-1, e2, e1),
                     `*` = gpuMatElemMult(e1, e2),
                     `/` = gpuMatElemDiv(e1,e2),
                     `^` = gpuMatElemPow(e1, e2),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)


#' @rdname Arith-methods
#' @export
setMethod("Arith", c(e1="matrix", e2="gpuMatrix"),
          function(e1, e2)
          {
              e1 <- gpuMatrix(e1, type = typeof(e2), ctx_id = e2@.context_index)
              
              op = .Generic[[1]]
              
              switch(op,
                     `+` = gpu_Mat_axpy(1, e1, e2),
                     `-` = gpu_Mat_axpy(-1, e2, e1),
                     `*` = gpuMatElemMult(e1, e2),
                     `/` = gpuMatElemDiv(e1,e2),
                     `^` = gpuMatElemPow(e1, e2),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)


#' @rdname Arith-methods
#' @export
setMethod("Arith", c(e1="gpuMatrix", e2="numeric"),
          function(e1, e2)
          {
#              assertive.properties::assert_is_of_length(e2, 1)
              
              op = .Generic[[1]]
              switch(op,
                     `+` = {
                         e2 <- gpuMatrix(matrix(e2, ncol=ncol(e1), nrow=nrow(e1)), type=typeof(e1), ctx_id=e1@.context_index)
                         gpu_Mat_axpy(1, e1, e2)
                     },
                     `-` = {
                         e2 <- gpuMatrix(matrix(e2, ncol=ncol(e1), nrow=nrow(e1)), type=typeof(e1), ctx_id=e1@.context_index)
                         gpu_Mat_axpy(-1, e2, e1)
                     },
                     `*` = gpuMatScalarMult(e1, e2),
                     `/` = gpuMatScalarDiv(e1, e2),
                     `^` = gpuMatScalarPow(e1, e2),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)


#' @rdname Arith-methods
#' @export
setMethod("Arith", c(e1="numeric", e2="gpuMatrix"),
          function(e1, e2)
          {
  #          assertive.properties::assert_is_of_length(e1, 1)
              
              op = .Generic[[1]]
              switch(op,
                     `+` = {
                         e1 = gpuMatrix(matrix(e1, ncol=ncol(e2), nrow=nrow(e2)), type=typeof(e2), ctx_id=e2@.context_index)
                         gpu_Mat_axpy(1, e1, e2)
                     },
                     `-` = {
                         e1 = gpuMatrix(matrix(e1, ncol=ncol(e2), nrow=nrow(e2)), type=typeof(e2), ctx_id=e2@.context_index)
                         gpu_Mat_axpy(-1, e2, e1)
                     },
                     `*` = gpuMatScalarMult(e2, e1),
                     `/` = {
                         e1 = gpuMatrix(matrix(e1, ncol=ncol(e2), nrow=nrow(e2)), type=typeof(e2), ctx_id=e2@.context_index)
                         gpuMatElemDiv(e1, e2)
                     },
                     `^` = {
                         e1 <- gpuMatrix(matrix(e1, ncol=ncol(e2), nrow=nrow(e2)), type=typeof(e2), ctx_id=e2@.context_index)
                         gpuMatElemPow(e1, e2)
                     },
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)



#' @rdname Arith-methods
#' @export
setMethod("Arith", c(e1="gpuMatrix", e2="missing"),
          function(e1, e2)
          {
              op = .Generic[[1]]
              switch(op,
                     `-` = gpuMatrix_unary_axpy(e1),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)


#' @rdname Arith-methods
#' @export
setMethod("Arith", c(e1="gpuMatrix", e2="gpuVector"),
          function(e1, e2)
          {
              op = .Generic[[1]]
              
              switch(op,
                     `+` = gpuMatVec_axpy(1, e1, e2),
                     `-` = gpuMatVec_axpy(-1, e2, e1),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)


#' @title gpuR Math methods
#' @description Methods for the base Math methods \link[methods]{S4groupGeneric}
#' @param x A gpuR object
#' @return A gpuMatrix object.
#' @details Currently implemented methods include:
#' \itemize{
#'  \item{"sin", "cos", "tan", "asin", "acos", "atan", "sinh", "cosh", "tanh",
#'  "log10", "exp", "abs", "sqrt", "sign"}
#'  }
#' @docType methods
#' @rdname Math-methods
#' @aliases Math-gpuR-method
#' @author Charles Determan Jr.
#' @export
setMethod("Math", c(x="gpuMatrix"),
          function(x)
          {
              op = .Generic[[1]]
              switch(op,
                     `sin` = gpuMatElemSin(x),
                     `asin` = gpuMatElemArcSin(x),
                     `sinh` = gpuMatElemHypSin(x),
                     `cos` = gpuMatElemCos(x),
                     `acos` = gpuMatElemArcCos(x),
                     `cosh` = gpuMatElemHypCos(x),
                     `tan` = gpuMatElemTan(x),
                     `atan` = gpuMatElemArcTan(x),
                     `tanh` = gpuMatElemHypTan(x),
                     `log10` = gpuMatElemLog10(x),
                     `exp` = gpuMatElemExp(x),
                     `abs` = gpuMatElemAbs(x),
                     `sqrt` = gpuMatSqrt(x),
                     `sign` = gpuMatSign(x),
                     stop("undefined operation")
              )
          },
          valueClass = "gpuMatrix"
)

#' @title gpuR Logarithms and Exponentials
#' @description \code{log} computes logarithms, by default natural logarithms
#' and \code{log10} computes common (i.e. base 10) logarithms.  The general form
#' \code{log(x, base)} computes logarithms with base \code{base}.
#'
#' \code{exp} computes the exponential function.
#' @param x A gpuR object
#' @param base A positive number (complex not currently supported by OpenCL):
#' the base with respect to which logarithms are computed.  Defaults to the
#' natural log.
#' @return A gpuR object of the same class as \code{x}
#' @docType methods
#' @rdname log-methods
#' @aliases log-gpuR-method
#' @export
setMethod("log", c(x="gpuMatrix"),
          function(x, base=NULL)
          {
              if(is.null(base)){
                  gpuMatElemLog(x)
              }else{
#                assertive.types::assert_is_numeric(base)
                  gpuMatElemLogBase(x, base)
              }
              
          },
          valueClass = "gpuMatrix"
)


#' @title The Number of Rows/Columns of a gpuR matrix
#' @description \code{nrow} and \code{ncol} return the number of rows or columns
#' present in \code{x} respectively.
#' @param x A gpuMatrix/vclMatrix object
#' @return An integer of length 1
#' @docType methods
#' @rdname nrow-gpuR
#' @author Charles Determan Jr.
#' @export
setMethod('nrow', signature(x="gpuMatrix"),
          function(x) {
              switch(typeof(x),
                     "integer" = return(cpp_gpuMatrix_nrow(x@address, 4L)),
                     "float" = return(cpp_gpuMatrix_nrow(x@address, 6L)),
                     "double" = return(cpp_gpuMatrix_nrow(x@address, 8L)),
                     "fcomplex" = return(cpp_gpuMatrix_nrow(x@address, 10L)),
                     "dcomplex" = return(cpp_gpuMatrix_nrow(x@address, 12L))
              )
          }
)

#' @rdname nrow-gpuR
#' @export
setMethod('ncol', signature(x="gpuMatrix"),
          function(x) {
              switch(typeof(x),
                     "integer" = return(cpp_gpuMatrix_ncol(x@address, 4L)),
                     "float" = return(cpp_gpuMatrix_ncol(x@address, 6L)),
                     "double" = return(cpp_gpuMatrix_ncol(x@address, 8L)),
                     "fcomplex" = return(cpp_gpuMatrix_ncol(x@address, 10L)),
                     "dcomplex" = return(cpp_gpuMatrix_ncol(x@address, 12L))
              )
          }
)


#' @title gpuMatrix/vclMatrix dim method
#' @description Retrieve dimension of object
#' @param x A gpuMatrix/vclMatrix object
#' @return A numeric vector of length 2: the number of 
#' rows and columns in the gpuR object `x`.
#' @docType methods
#' @rdname dim-methods
#' @author Charles Determan Jr.
#' @aliases dim-gpuMatrix
#' @export
setMethod('dim', signature(x="gpuMatrix"),
          function(x) return(c(nrow(x), ncol(x))))

#' @title gpuMatrix/vclMatrix length method
#' @description Retrieve number of elements in object
#' @param x A gpuMatrix/vclMatrix object
#' @return A numeric value
#' @docType methods
#' @rdname length-methods
#' @author Charles Determan Jr.
#' @aliases length-gpuMatrix
#' @export
setMethod('length', signature(x="gpuMatrix"),
          function(x) return(nrow(x) * ncol(x)))


#' @title Row and Column Sums and Means of gpuMatrix
#' @description Row and column sums and of gpuMatrix objects
#' @param x A gpuMatrix object
#' @return A gpuvector containing the sum of each column in the gpuMatrix.
#' @author Charles Determan Jr.
#' @docType methods
#' @rdname gpuMatrix.colSums
#' @aliases colSums,gpuMatrix
#' @aliases rowSums,gpuMatrix
#' @export
setMethod("colSums",
          signature(x = "gpuMatrix"),
          function(x){
              gpu_colSums(x)
          })

#' @rdname gpuMatrix.colSums
#' @return A gpuvector containing the sum of each row in the gpuMatrix.
#' @export
setMethod("rowSums",
          signature(x = "gpuMatrix"),
          function(x){
              gpu_rowSums(x)
          })



#' @rdname gpuMatrix.colSums
#' @return A gpuvector containing the mean of each column in the gpuMatrix.
#' @export
setMethod("colMeans",
          signature(x = "gpuMatrix"),
          function(x){
              gpu_colMeans(x)
          })


#' @rdname gpuMatrix.colSums
#' @return A gpuvector containing the mean of each row in the gpuMatrix.
#' @export
setMethod("rowMeans",
          signature(x = "gpuMatrix"),
          function(x){
              gpu_rowMeans(x)
          })


#' @title Covariance (gpuR)
#' @description Compute covariance values
#' @param x A gpuR object
#' @param y A gpuR object
#' @param use Not used
#' @param method Character string indicating with covariance to be computed.
#' @return A gpuMatrix/vclMatrix containing the symmetric covariance values.
#' @author Charles Determan Jr.
#' @docType methods
#' @rdname cov-methods
#' @export
setMethod("cov",
          signature(x = "gpuMatrix", y = "missing", use = "missing", method = "missing"),
          function(x, y = NULL, use = NULL, method = "pearson") {
              if(method != "pearson"){
                  stop("Only pearson covariance implemented")
              }
              return(gpu_pmcc(x))
          })


#' @rdname cov-methods
#' @export
setMethod("cov",
          signature(x = "gpuMatrix", y = "gpuMatrix", use = "missing", method = "missing"),
          function(x, y = NULL, use = NULL, method = "pearson") {
              if(method != "pearson"){
                  stop("Only pearson covariance implemented")
              }
              return(gpu_pmcc(x, y))
          })




#' @rdname cov-methods
#' @export
setMethod("cov",
          signature(x = "gpuMatrix", y = "missing", use = "missing", method = "character"),
          function(x, y = NULL, use = NULL, method = "pearson") {
              if(method != "pearson"){
                  stop("Only pearson covariance implemented")
              }
              return(gpu_pmcc(x))
          })

#' @rdname cov-methods
#' @export
setMethod("cov",
          signature(x = "gpuMatrix", y = "gpuMatrix", use = "missing", method = "character"),
          function(x, y = NULL, use = NULL, method = "pearson") {
              if(method != "pearson"){
                  stop("Only pearson covariance implemented")
              }
              return(gpu_pmcc(x))
          })


#' @title gpuMatrix Crossproduct
#' @description Return the matrix cross-product of two conformable
#' matrices using a GPU.  This is equivalent to t(x) %*% y (crossprod)
#' or x %*% t(t) (tcrossprod) but faster as no data transfer between
#' device and host is required.
#' @param x A gpuMatrix
#' @param y A gpuMatrix
#' @return A gpuMatrix
#' @author Charles Determan Jr.
#' @docType methods
#' @rdname gpuMatrix-crossprod
#' @aliases crossprod,gpuMatrix
#' @export
setMethod("crossprod",
          signature(x = "gpuMatrix", y = "missing"),
          function(x, y){
              gpu_crossprod(x, x)
          })



#' @rdname gpuMatrix-crossprod
#' @export
setMethod("crossprod",
          signature(x = "gpuMatrix", y = "gpuMatrix"),
          function(x, y){
              gpu_crossprod(x, y)
          })



#' @rdname gpuMatrix-crossprod
#' @export
setMethod("crossprod",
          signature(x = "gpuMatrix", y = "matrix"),
          function(x, y){
              y <- gpuMatrix(y, type = typeof(x), ctx_id = x@.context_index)
              gpu_crossprod(x, y)
          })



#' @rdname gpuMatrix-crossprod
#' @export
setMethod("crossprod",
          signature(x = "matrix", y = "gpuMatrix"),
          function(x, y){
              x <- gpuMatrix(x, type = typeof(y), ctx_id = y@.context_index)
              gpu_crossprod(x, y)
          })



#' @rdname gpuMatrix-crossprod
setMethod("tcrossprod",
          signature(x = "gpuMatrix", y = "missing"),
          function(x, y){
              gpu_tcrossprod(x, x)
          })


#' @rdname gpuMatrix-crossprod
#' @export
setMethod("tcrossprod",
          signature(x = "gpuMatrix", y = "gpuMatrix"),
          function(x, y){
              gpu_tcrossprod(x, y)
          })

#' @rdname gpuMatrix-crossprod
#' @export
setMethod("tcrossprod",
          signature(x = "matrix", y = "gpuMatrix"),
          function(x, y){
              x <- gpuMatrix(x, type = typeof(y), ctx_id = y@.context_index)
              gpu_tcrossprod(x, y)
          })



#' @rdname gpuMatrix-crossprod
#' @export
setMethod("tcrossprod",
          signature(x = "gpuMatrix", y = "matrix"),
          function(x, y){
              y <- gpuMatrix(y, type = typeof(x), ctx_id = x@.context_index)
              gpu_tcrossprod(x, y)
          })




#' @rdname dist-vclMatrix
#' @aliases dist,gpuMatrix
#' @export
setMethod("dist", signature(x="gpuMatrix"),
          function(x, method = "euclidean", diag = FALSE, upper = FALSE, p = 2)
          {
              
              type = typeof(x)
              
              # if( type == "integer"){
              #     stop("Integer type not currently supported")
              # }
              
              D <- gpuMatrix(nrow=nrow(x), ncol=nrow(x), type=type)
              
              switch(method,
                     "euclidean" = gpuMatrix_euclidean(
                         x,
                         D,
                         diag,
                         upper,
                         p,
                         FALSE),
                     "sqEuclidean" = gpuMatrix_euclidean(
                         x,
                         D,
                         diag,
                         upper,
                         p,
                         TRUE),
                     stop("method not currently supported")
              )
              
              return(D)
          }
)




#' @rdname dist-vclMatrix
#' @aliases distance,gpuMatrix
setMethod("distance", signature(x = "gpuMatrix", y = "gpuMatrix"),
          function(x, y, method = "euclidean")
          {
              if(identical(x, y)){
                  same <- TRUE
                  warning("x is the same as y, did you mean to use 'dist' instead?")
              }else{
                  same <- FALSE
              }
              
              if(ncol(x) != ncol(y)){
                  stop("columns in x and y are not equivalent")
              }
              
              type = typeof(x)
              
              # if( type == "integer"){
              #     stop("Integer type not currently supported")
              # }
              
              D <- gpuMatrix(nrow=nrow(x), ncol=nrow(y), type=type)
              
              switch(method,
                     "euclidean" = gpuMatrix_peuclidean(
                         x,
                         y,
                         D,
                         FALSE),
                     "sqEuclidean" = gpuMatrix_peuclidean(
                         x,
                         y,
                         D,
                         TRUE),
                     stop("method not currently supported")
              )
              
              if(same){
                  for(i in 1:ncol(D)){
                      D[i,i] <- 0
                  }
              }
              
              return(D)
          }
)



#' @return A deep copy of the input \code{gpuMatrix} object.
#' @rdname gpuR-deepcopy
setMethod("deepcopy", signature(object ="gpuMatrix"),
          function(object){
              
              out <- switch(typeof(object),
                            "integer" = new(class(object)[1],
                                            address = cpp_deepcopy_gpuMatrix(object@address, 4L),
                                            .context_index = object@.context_index,
                                            .platform_index = object@.platform_index,
                                            .platform = object@.platform,
                                            .device_index = object@.device_index,
                                            .device = object@.device),
                            "float" = new(class(object)[1],
                                          address = cpp_deepcopy_gpuMatrix(object@address, 6L),
                                          .context_index = object@.context_index,
                                          .platform_index = object@.platform_index,
                                          .platform = object@.platform,
                                          .device_index = object@.device_index,
                                          .device = object@.device),
                            "double" = new(class(object)[1],
                                           address = cpp_deepcopy_gpuMatrix(object@address, 8L),
                                           .context_index = object@.context_index,
                                           .platform_index = object@.platform_index,
                                           .platform = object@.platform,
                                           .device_index = object@.device_index,
                                           .device = object@.device),
                            stop("unrecognized type")
              )
              return(out)
              
          })



#' @rdname gpuR-block
setMethod("block",
          signature(object = "gpuMatrix",
                    rowStart = "integer", rowEnd = "integer",
                    colStart = "integer", colEnd = "integer"),
          function(object, rowStart, rowEnd, colStart, colEnd){
              
            assert_all_are_positive(c(rowStart, rowEnd, colStart, colEnd))
            assert_all_are_in_range(c(rowStart, rowEnd), lower = 1, upper = nrow(object)+1)
            assert_all_are_in_range(c(colStart, colEnd), lower = 1, upper = ncol(object)+1)
              
              ptr <- switch(typeof(object),
                            "float" = {
                                address <- gpuMatBlock(object@address, rowStart, rowEnd, colStart, colEnd, 6L)
                                new("fgpuMatrixBlock",
                                    address = address,
                                    .context_index = object@.context_index,
                                    .platform_index = object@.platform_index,
                                    .platform = object@.platform,
                                    .device_index = object@.device_index,
                                    .device = object@.device)
                            },
                            "double" = {
                                address <- gpuMatBlock(object@address, rowStart, rowEnd, colStart, colEnd, 8L)
                                new("dgpuMatrixBlock",
                                    address = address,
                                    .context_index = object@.context_index,
                                    .platform_index = object@.platform_index,
                                    .platform = object@.platform,
                                    .device_index = object@.device_index,
                                    .device = object@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
              
          })

#' @return A gpuMatrix object.
setMethod("cbind2",
          signature(x = "gpuMatrix", y = "gpuMatrix"),
          function(x, y, ...){
              if(nrow(x) != nrow(y)){
                  stop("number of rows of matrices must match")
              }
              
              ptr <- switch(typeof(x),
                            "integer" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 4L)
                                new("igpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "float" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 6L)
                                new("fgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "double" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 8L)
                                new("dgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
          })



#' @return A gpuMatrix object.
setMethod("cbind2",
          signature(x = "numeric", y = "gpuMatrix"),
          function(x, y, ...){
              
              x <- gpuMatrix(x, nrow=nrow(y), ncol=1, type=typeof(y))
              
              ptr <- switch(typeof(x),
                            "integer" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 4L)
                                new("igpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "float" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 6L)
                                new("fgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "double" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 8L)
                                new("dgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
          })



#' @return A gpuMatrix object.
setMethod("cbind2",
          signature(x = "gpuMatrix", y = "numeric"),
          function(x, y, ...){
              
              y <- gpuMatrix(y, nrow=nrow(x), ncol=1, type=typeof(x))
              
              ptr <- switch(typeof(x),
                            "integer" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 4L)
                                new("igpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "float" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 6L)
                                new("fgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "double" = {
                                address <- cpp_cbind_gpuMatrix(x@address, y@address, 8L)
                                new("dgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
          })



#' @return A gpuMatrix object.
setMethod("rbind2",
          signature(x = "gpuMatrix", y = "gpuMatrix"),
          function(x, y, ...){
              if(ncol(x) != ncol(y)){
                  stop("number of columns of matrices must match")
              }
              
              ptr <- switch(typeof(x),
                            "integer" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 4L)
                                new("igpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "float" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 6L)
                                new("fgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "double" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 8L)
                                new("dgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
          })



#' @return A gpuMatrix object.
setMethod("rbind2",
          signature(x = "numeric", y = "gpuMatrix"),
          function(x, y, ...){
              
              x <- gpuMatrix(x, nrow=1, ncol=ncol(y), type=typeof(y))
              
              ptr <- switch(typeof(x),
                            "integer" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 4L)
                                new("igpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "float" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 6L)
                                new("fgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "double" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 8L)
                                new("dgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
          })


#' @return A gpuMatrix object.
setMethod("rbind2",
          signature(x = "gpuMatrix", y = "numeric"),
          function(x, y, ...){
              
              y <- gpuMatrix(y, nrow=1, ncol=ncol(x), type=typeof(x))
              
              ptr <- switch(typeof(x),
                            "integer" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 4L)
                                new("igpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "float" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 6L)
                                new("fgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            "double" = {
                                address <- cpp_rbind_gpuMatrix(x@address, y@address, 8L)
                                new("dgpuMatrix",
                                    address = address,
                                    .context_index = x@.context_index,
                                    .platform_index = x@.platform_index,
                                    .platform = x@.platform,
                                    .device_index = x@.device_index,
                                    .device = x@.device)
                            },
                            stop("type not recognized")
              )
              
              return(ptr)
          })


#' @title gpuR Summary methods
#' @description Methods for the base Summary methods \link[methods]{S4groupGeneric}
#' @param x A gpuR object
#' @param ... Additional arguments passed to method (not currently used)
#' @param na.rm a logical indicating whether missing values should be removed (
#' not currently used)
#' @return For \code{min} or \code{max}, a length-one vector
#' @docType methods
#' @rdname Summary-methods
#' @aliases Summary-gpuR-method
#' @export
setMethod("Summary", c(x="gpuMatrix"),
          function(x, ..., na.rm)
          {
              op = .Generic
              result <- switch(op,
                               `max` = gpuMatrix_max(x),
                               `min` = gpuMatrix_min(x),
                               `sum` = gpuMatrix_sum(x),
                               stop("undefined operation")
              )
              return(result)
          }
)

#' @title \code{gpuR} matrix transpose
#' @description Given a \code{gpuR} matrix \code{x}, \code{t} returns the 
#' transpose of \code{x}
#' @param x A \code{gpuR} matrix
#' @return A \code{gpuR} matrix
#' @author Charles Determan Jr.
#' @rdname t-methods
#' @aliases t,gpuMatrix
#' @export
setMethod("t", c(x = "gpuMatrix"),
          function(x){
              return(gpuMatrix_t(x))
          }
)

#' @rdname diag-methods
#' @aliases diag,gpuMatrix
#' @export
setMethod("diag", c(x = "gpuMatrix"),
          function(x){
              # get diagonal elements
              return(gpuMatrix_get_diag(x))
          }
)

#' @rdname diag-methods
#' @aliases diag<-,gpuMatrix,gpuVector
#' @export
setMethod("diag<-", c(x = "gpuMatrix", value = "gpuVector"),
          function(x, value){
              
              if(nrow(x) != length(value)){
                  stop("replacement diagnonal has wrong length")
              }
              
              # get diagonal elements
              gpuMat_gpuVec_set_diag(x, value)
              
              return(invisible(x))
          }
)

#' @rdname det-methods
#' @aliases det,vclMatrix
#' @export
setMethod("det", c(x = "gpuMatrix"),
          function(x){
              return(gpuMat_det(x))
          }
)
