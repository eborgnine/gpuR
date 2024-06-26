
# GPU vector pmax/pmin
gpuMatpmax <- function(..., order){
    
    thresholds <- list(...)
    A <- thresholds[[1]]
    
    # remove from list
    thresholds[[1]] <- NULL
    
    type <- typeof(A)
    
    # B <- vclVector(length = length(A), type=type, ctx_id = A@.context_index)
    B <- deepcopy(A)
    
    
    maxWorkGroupSize <- 
        switch(deviceType(B@.device_index, B@.context_index),
               "gpu" = gpuInfo(B@.device_index, B@.context_index)$maxWorkGroupSize,
               "cpu" = cpuInfo(B@.device_index, B@.context_index)$maxWorkGroupSize,
               stop("unrecognized device type")
        )
    
    
    kernel <- switch(type,
                     integer = {
                         if(order == 1L){
                             file <- system.file("CL", "iMat_pmax.cl", package = "gpuR")    
                         }else{
                             file <- system.file("CL", "iMat_pmin.cl", package = "gpuR")
                         }
                         
                         if(!file_test("-f", file)){
                             stop("kernel file does not exist")
                         }
                         readChar(file, file.info(file)$size)
                     },
                     float = {
                         if(order == 1L){
                             file <- system.file("CL", "fMat_pmax.cl", package = "gpuR")    
                         }else{
                             file <- system.file("CL", "fMat_pmin.cl", package = "gpuR")
                         }
                         
                         if(!file_test("-f", file)){
                             stop("kernel file does not exist")
                         }
                         readChar(file, file.info(file)$size)
                     },
                     double = {
                         if(order == 1L){
                             file <- system.file("CL", "dMat_pmax.cl", package = "gpuR")    
                         }else{
                             file <- system.file("CL", "dMat_pmin.cl", package = "gpuR")
                         }
                         
                         if(!file_test("-f", file)){
                             stop("kernel file does not exist")
                         }
                         readChar(file, file.info(file)$size)
                     },
                     stop("type not recognized")
    )
    
    for(threshold in thresholds){
        
        switch(type,
               integer = {
                   cpp_vclMatrix_pmax(B@address,
                                      is(B, "vclMatrix"),
                                      B@address,
                                      is(B, "vclMatrix"),
                                      threshold,
                                      kernel,
                                      sqrt(maxWorkGroupSize),
                                      4L,
                                      A@.context_index - 1L)
               },
               float = {
                   cpp_vclMatrix_pmax(B@address,
                                      is(B, "vclMatrix"),
                                      B@address,
                                      is(B, "vclMatrix"),
                                      threshold,
                                      kernel,
                                      sqrt(maxWorkGroupSize),
                                      6L,
                                      A@.context_index - 1L)
               },
               double = {
                   cpp_vclMatrix_pmax(B@address,
                                      is(B, "vclMatrix"),
                                      B@address,
                                      is(B, "vclMatrix"),
                                      threshold,
                                      kernel,
                                      sqrt(maxWorkGroupSize),
                                      8L,
                                      A@.context_index - 1L)
               }
        )    
    }
    
    return(B)
}

# GPU vector pmax/pmin
gpuVecpmax <- function(..., order){
    
    thresholds <- list(...)
    A <- thresholds[[1]]
    
    # remove from list
    thresholds[[1]] <- NULL
    
    type <- typeof(A)
    
    # B <- vclVector(length = length(A), type=type, ctx_id = A@.context_index)
    B <- deepcopy(A)
    
    
    maxWorkGroupSize <- 
        switch(deviceType(B@.device_index, B@.context_index),
               "gpu" = gpuInfo(B@.device_index, B@.context_index)$maxWorkGroupSize,
               "cpu" = cpuInfo(B@.device_index, B@.context_index)$maxWorkGroupSize,
               stop("unrecognized device type")
        )
    
    
    kernel <- switch(type,
                     integer = {
                         if(order == 1L){
                             file <- system.file("CL", "iVec_pmax.cl", package = "gpuR")    
                         }else{
                             file <- system.file("CL", "iVec_pmin.cl", package = "gpuR")
                         }
                         
                         if(!file_test("-f", file)){
                             stop("kernel file does not exist")
                         }
                         readChar(file, file.info(file)$size)
                     },
                     float = {
                         if(order == 1L){
                             file <- system.file("CL", "fVec_pmax.cl", package = "gpuR")    
                         }else{
                             file <- system.file("CL", "fVec_pmin.cl", package = "gpuR")
                         }
                         
                         if(!file_test("-f", file)){
                             stop("kernel file does not exist")
                         }
                         readChar(file, file.info(file)$size)
                     },
                     double = {
                         if(order == 1L){
                             file <- system.file("CL", "dVec_pmax.cl", package = "gpuR")    
                         }else{
                             file <- system.file("CL", "dVec_pmin.cl", package = "gpuR")
                         }
                         
                         if(!file_test("-f", file)){
                             stop("kernel file does not exist")
                         }
                         readChar(file, file.info(file)$size)
                     },
                     stop("type not recognized")
    )
    
    for(threshold in thresholds){
        
        switch(type,
               integer = {
                   cpp_vclVector_pmax(B@address,
                                      is(B, "vclVector"),
                                      B@address,
                                      is(B, "vclVector"),
                                      threshold,
                                      kernel,
                                      maxWorkGroupSize,
                                      4L,
                                      A@.context_index - 1L)
               },
               float = {
                   cpp_vclVector_pmax(B@address,
                                      is(B, "vclVector"),
                                      B@address,
                                      is(B, "vclVector"),
                                      threshold,
                                      kernel,
                                      maxWorkGroupSize,
                                      6L,
                                      A@.context_index - 1L)
               },
               double = {
                   cpp_vclVector_pmax(B@address,
                                      is(B, "vclVector"),
                                      B@address,
                                      is(B, "vclVector"),
                                      threshold,
                                      kernel,
                                      maxWorkGroupSize,
                                      8L,
                                      A@.context_index - 1L)
               }
        )    
    }
    
    return(B)
}


#' @title Parallel Maxima and Minima
#' @description \code{pmax} and \code{pmin} take one or more
#' vectors as arguments and return a single vector giving the 'parallel'
#' maxima (or minima) of the argument vectors
#' @param ... gpuR or numeric arguments
#' @return A vclMatrix object.
#' @seealso \link[base]{pmax} \link[base]{pmin}
#' @rdname pmax
#' @export
pmax <- function(...){ UseMethod("pmax") }
#' @export
pmax.default <- function(..., na.rm=FALSE){ base::pmax(..., na.rm=FALSE) }

#' @rdname pmax
#' @export
pmin <- function(...){ UseMethod("pmin") }
#' @export
pmin.default <- function(..., na.rm=FALSE){ base::pmin(..., na.rm=FALSE) }


#' @export
pmax.vclVector <- function(..., na.rm = FALSE){

    gpuVecpmax(..., order = 1L)
}
#' @export
pmax.vclMatrix <- function(..., na.rm = FALSE){

    gpuMatpmax(..., order = 1L)
}
#' @export
pmax.gpuVector <- function(..., na.rm = FALSE){

    gpuVecpmax(..., order = 1L)
}
#' @export
pmax.gpuMatrix <- function(..., na.rm = FALSE){

    gpuMatpmax(..., order = 1L)
}



#' @rdname pmax
#' @param ... a vclVector object
#' @param na.rm a logical indicating whether missing values should be removed. 
#' @export
pmin.vclVector <- function(..., na.rm = FALSE){
    gpuVecpmax(..., order = -1L)
}
#' @export
pmin.vclMatrix <- function(..., na.rm = FALSE){
    gpuMatpmax(..., order = -1L)
}
#' @export
pmin.gpuVector <- function(..., na.rm = FALSE){
    gpuVecpmax(..., order = -1L)
}
#' @export
pmin.gpuMatrix <- function(..., na.rm = FALSE){
    gpuMatpmax(..., order = -1L)
}
