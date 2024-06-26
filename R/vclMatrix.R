
# need code to reshape if dimensions differ from input

#' @title Construct a vclMatrix
#' @description Construct a vclMatrix of a class that inherits
#' from \code{vclMatrix}.  This class points to memory directly on
#' the GPU to avoid the cost of data transfer between host and device.
#' @param data An object that is or can be converted to a 
#' \code{matrix} object
#' @param nrow An integer specifying the number of rows
#' @param ncol An integer specifying the number of columns
#' @param type A character string specifying the type of vclMatrix.  Default
#' is NULL where type is inherited from the source data type.
#' @param ctx_id An integer specifying the object's context
#' @param ... Additional method to pass to vclMatrix methods
#' @return A vclMatrix object
#' @docType methods
#' @rdname vclMatrix-methods
#' @author Charles Determan Jr.
#' @export
setGeneric("vclMatrix", function(data = NA, nrow=NA, ncol=NA, type=NULL, ...){
    standardGeneric("vclMatrix")
})

#' @rdname vclMatrix-methods
#' @aliases vclMatrix,matrix
setMethod('vclMatrix', 
          signature(data = 'matrix'),
          function(data, type=NULL, ctx_id=NULL){
              
              if (is.null(type)){
                  if(typeof(data) == "integer") {
                      type <- "integer"
                  }else{
                      type <- getOption("gpuR.default.type")    
                  }
              }
              
              if(type == "complex"){
                  warning("default complex type is double (dcomplex)")
                  type <- 'dcomplex'
              }

              device <- if(is.null(ctx_id)) currentDevice() else listContexts()[ctx_id,]
              
              context_index <- ifelse(is.null(ctx_id), currentContext(), as.integer(ctx_id))
              device_index <- if(is.null(ctx_id)) as.integer(device$device_index) else device$device_index + 1L
              
              platform_index <- if(is.null(ctx_id)) currentPlatform()$platform_index else device$platform_index + 1L
              platform_name <- platformInfo(platform_index)$platformName
              
              device_type <- device$device_type
              device_name <- switch(device_type,
                                    "gpu" = gpuInfo(
                                        device_idx = as.integer(device_index),
                                        context_idx = context_index)$deviceName,
                                    "cpu" = cpuInfo(
                                        device_idx = as.integer(device_index),
                                        context_idx = context_index)$deviceName,
                                    stop("Unrecognized device type")
              )
              
              data = switch(type,
                            integer = {
                                new("ivclMatrix", 
                                    address=cpp_sexp_mat_to_vclMatrix(data, 4L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            float = {
                                new("fvclMatrix", 
                                    address=cpp_sexp_mat_to_vclMatrix(data, 6L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            double = {
                                assert_has_double(device_index, context_index)
                                new("dvclMatrix",
                                    address = cpp_sexp_mat_to_vclMatrix(data, 8L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            fcomplex = {
                                new("cvclMatrix", 
                                    address=cpp_sexp_mat_to_vclMatrix(data, 10L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            dcomplex = {
                                assert_has_double(device_index, context_index)
                                new("zvclMatrix",
                                    address = cpp_sexp_mat_to_vclMatrix(data, 12L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            stop("this is an unrecognized 
                                 or unimplemented data type")
                            )
              return(data)
          },
          valueClass = "vclMatrix")


#' @rdname vclMatrix-methods
#' @aliases vclMatrix,missing
setMethod('vclMatrix', 
          signature(data = 'missing'),
          function(data, nrow=NA, ncol=NA, type=NULL, ctx_id = NULL){
              
              if (is.null(type)) type <- getOption("gpuR.default.type")
            
              device <- if(is.null(ctx_id)) currentDevice() else listContexts()[ctx_id,]

              context_index <- ifelse(is.null(ctx_id), currentContext(), as.integer(ctx_id))
              device_index <- if(is.null(ctx_id)) as.integer(device$device_index) else device$device_index + 1L
              
              platform_index <- if(is.null(ctx_id)) currentPlatform()$platform_index else device$platform_index + 1L
              platform_name <- platformInfo(platform_index)$platformName
              
              device_type <- device$device_type
              device_name <- switch(device_type,
                                    "gpu" = gpuInfo(
                                        device_idx = as.integer(device_index),
                                        context_idx = context_index)$deviceName,
                                    "cpu" = cpuInfo(
                                        device_idx = as.integer(device_index),
                                        context_idx = context_index)$deviceName,
                                    stop("Unrecognized device type")
              )
              
              data = switch(type,
                            integer = {
                                new("ivclMatrix", 
                                    address=cpp_zero_vclMatrix(nrow, ncol, 4L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            float = {
                                new("fvclMatrix", 
                                    address=cpp_zero_vclMatrix(nrow, ncol, 6L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            double = {
                                assert_has_double(device_index, context_index)
                                new("dvclMatrix",
                                    address = cpp_zero_vclMatrix(nrow, ncol, 8L, context_index - 1),
                                    .context_index = context_index,
                                    .platform_index = platform_index,
                                    .platform = platform_name,
                                    .device_index = device_index,
                                    .device = device_name)
                            },
                            stop("this is an unrecognized 
                                 or unimplemented data type")
                            )
              
              return(data)
          },
          valueClass = "vclMatrix")



#' @rdname vclMatrix-methods
#' @aliases vclMatrix,vector
#' @aliases vclMatrix,numeric
setMethod('vclMatrix', 
          signature(data = 'numeric'),
          function(data, nrow, ncol, type=NULL, ctx_id=NULL){
              
              if (is.null(type)) type <- getOption("gpuR.default.type")
#               device_flag <- ifelse(options("gpuR.default.device.type") == "gpu", 0, 1)
              
              if(is.na(nrow)) stop("must indicate number of rows: nrow")
              if(is.na(ncol)) stop("must indicate number of columns: ncol")
#              assertive.types::assert_is_numeric(nrow)
#              assertive.types::assert_is_numeric(ncol)
              
              if(length(data) == 1){
                  data <- vclMatInitNumScalar(data, nrow, ncol, type, ctx_id)
              }else{
                  data <- vclMatInitNumVec(data, nrow, ncol, type, ctx_id)
              }
              
              return(data)
          },
          valueClass = "vclMatrix")

#' @rdname vclMatrix-methods
#' @aliases vclMatrix,integer
setMethod('vclMatrix',
          signature(data = 'integer'),
          function(data, nrow, ncol, type=NULL, ctx_id=NULL){
              
              if (is.null(type)) type <- "integer"
              device_flag <- ifelse(options("gpuR.default.device.type") == "gpu", 0, 1)
              
              if(is.na(nrow)) stop("must indicate number of rows: nrow")
              if(is.na(ncol)) stop("must indicate number of columns: ncol")
#              assertive.types::assert_is_numeric(nrow)
#              assertive.types::assert_is_numeric(ncol)
              
              if(length(data) == 1){
                  data <- vclMatInitIntScalar(data, nrow, ncol, type, ctx_id)
              }else{
                  data <- vclMatInitIntVec(data, nrow, ncol, type, ctx_id)
              }
              
              return(data)
          },
          valueClass = "vclMatrix"
)

