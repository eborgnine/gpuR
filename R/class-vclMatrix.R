# The primary class for all vclMatrix objects

#' @title vclMatrix Class
#' @description This is the 'mother' class for all
#' vclMatrix objects.  These objects are pointers
#' to viennacl matrices directly on the GPU.  This will 
#' avoid the overhead of passing data back and forth 
#' between the host and device.
#' 
#' As such, any changes made
#' to normal R 'copies' (e.g. A <- B) will be propogated to
#' the parent object.
#' 
#' There are multiple child classes that correspond
#' to the particular data type contained.  These include
#' \code{ivclMatrix}, \code{fvclMatrix}, and 
#' \code{dvclMatrix} corresponding to integer, float, and
#' double data types respectively.
#' @section Slots:
#'  Common to all vclMatrix objects in the package
#'  \describe{
#'      \item{\code{address}:}{Pointer to data matrix}
#'      \item{\code{.context_index}:}{Integer index of OpenCL contexts}
#'      \item{\code{.platform_index}:}{Integer index of OpenCL platforms}
#'      \item{\code{.platform}:}{Name of OpenCL platform}
#'      \item{\code{.device_index}:}{Integer index of active device}
#'      \item{\code{.device}:}{Name of active device}
#'  }
#' @return An object of class 'vclMatrix' with the specified slots.
#' @note R does not contain a native float type.  As such,
#' the matrix data within a \code{\link{fvclMatrix-class}} 
#' will be represented as double but downcast when any 
#' vclMatrix methods are used.
#' 
#' May also remove the type slot
#' 
#' @name vclMatrix-class
#' @rdname vclMatrix-class
#' @author Charles Determan Jr.
#' @seealso \code{\link{ivclMatrix-class}}, 
#' \code{\link{fvclMatrix-class}},
#' \code{\link{dvclMatrix-class}}
#' @export
setClass('vclMatrix', 
         slots = c(address="externalptr",
                   .context_index = "integer",
                   .platform_index = "integer",
                   .platform = "character",
                   .device_index = "integer",
                   .device = "character"))


#' @title ivclMatrix Class
#' @description An integer type matrix in the S4 \code{vclMatrix}
#' representation.
#' @section Slots:
#'  \describe{
#'      \item{\code{address}:}{Pointer to a integer typed matrix}
#'  }
#' @name ivclMatrix-class
#' @rdname ivclMatrix-class
#' @author Charles Determan Jr.
#' @return If the vclMatrix object is of type 'integer', returns TRUE, if not, returns an error message. 
#' @seealso \code{\link{vclMatrix-class}}, 
#' \code{\link{ivclMatrix-class}},
#' \code{\link{dvclMatrix-class}}
#' @export
setClass("ivclMatrix",
         contains = "vclMatrix",
         validity = function(object) {
             if( typeof(object) != "integer"){
                 return("ivclMatrix must be of type 'integer'")
             }
             TRUE
         })


#' @title fvclMatrix Class
#' @description An integer type matrix in the S4 \code{vclMatrix}
#' representation.
#' @section Slots:
#'  \describe{
#'      \item{\code{address}:}{Pointer to a float matrix.}
#'  }
#' @name fvclMatrix-class
#' @rdname fvclMatrix-class
#' @author Charles Determan Jr.
#' @return If the vclMatrix object is of type 'float', returns TRUE, if not, returns an error message. 
#' @seealso \code{\link{vclMatrix-class}}, 
#' \code{\link{ivclMatrix-class}},
#' \code{\link{dvclMatrix-class}}
#' @export
setClass("fvclMatrix",
         contains = "vclMatrix",
         validity = function(object) {
             if( typeof(object) != "float"){
                 return("fvclMatrix must be of type 'float'")
             }
             TRUE
         })


#' @title dvclMatrix Class
#' @description An integer type matrix in the S4 \code{vclMatrix}
#' representation.
#' @section Slots:
#'  \describe{
#'      \item{\code{address}:}{Pointer to a double type matrix}
#'  }
#' @name dvclMatrix-class
#' @rdname dvclMatrix-class
#' @author Charles Determan Jr.
#' @return If the vclMatrix object is of type 'double', returns TRUE, if not, returns an error message. 
#' @seealso \code{\link{vclMatrix-class}}, 
#' \code{\link{ivclMatrix-class}},
#' \code{\link{fvclMatrix-class}}
#' @export
setClass("dvclMatrix",
         contains = "vclMatrix",
         validity = function(object) {
             if( typeof(object) != "double"){
                 return("dvclMatrix must be of type 'double'")
             }
             TRUE
         })

#' @title cvclMatrix Class
#' @description An complex float type matrix in the S4 \code{vclMatrix}
#' representation.
#' @section Slots:
#'  \describe{
#'      \item{\code{address}:}{Pointer to a complex float type matrix}
#'  }
#' @name cvclMatrix-class
#' @rdname cvclMatrix-class
#' @author Charles Determan Jr.
#' @return If the vclMatrix object is of type 'complex float', returns TRUE, if not, returns an error message. 
#' @seealso \code{\link{vclMatrix-class}}, 
#' \code{\link{ivclMatrix-class}},
#' \code{\link{fvclMatrix-class}}
#' @export
setClass("cvclMatrix",
         contains = "vclMatrix",
         validity = function(object) {
             if( typeof(object) != "fcomplex"){
                 return("cvclMatrix must be of type 'fcomplex'")
             }
             TRUE
         })

#' @title zvclMatrix Class
#' @description An complex double type matrix in the S4 \code{vclMatrix}
#' representation.
#' @section Slots:
#'  \describe{
#'      \item{\code{address}:}{Pointer to a complex double type matrix}
#'  }
#' @name zvclMatrix-class
#' @rdname zvclMatrix-class
#' @author Charles Determan Jr.
#' @return If the vclMatrix object is of type 'complex double', returns TRUE, if not, returns an error message. 
#' @seealso \code{\link{vclMatrix-class}}, 
#' \code{\link{ivclMatrix-class}},
#' \code{\link{fvclMatrix-class}}
#' @export
setClass("zvclMatrix",
         contains = "vclMatrix",
         validity = function(object) {
             if( typeof(object) != "dcomplex"){
                 return("zvclMatrix must be of type 'dcomplex'")
             }
             TRUE
         })

# @export
setClass("ivclMatrixBlock", 
         contains = "ivclMatrix")

# @export
setClass("fvclMatrixBlock", 
         contains = "fvclMatrix")

# @export
setClass("dvclMatrixBlock", 
         contains = "dvclMatrix")

