###################################
### Unit Test Utility Functions ###
###################################

# The following functions are simply used to facilitate
# the unit tests implemented by this package.  For example, the user
# may install this package with the correct drivers but not have any
# valid GPU devices or a valid GPU may not support double precision.
# These functions will allow some tests to be skipped so that all
# relevant functions can be evaluated.

# check if any GPUs can be found
#' @title Skip test for GPUs
#' @description Function to skip testthat tests
#' if no valid GPU's are detected
#' @return Returns nothing but gives a message if no GPUs available.
#' @export
has_gpu_skip <- function() {
    gpuCheck <- try(detectGPUs(), silent=TRUE)
    if(class(gpuCheck)[1] == "try-error"){
        testthat::skip("No GPUs available")
    }else{
        if (gpuCheck == 0) {
            testthat::skip("No GPUs available")
        }
    }
}

# check if multiple GPUs can be found
#' @title Skip test in less than 2 GPUs
#' @description Function to skip testthat tests
#' if less than 2 valid GPU's are detected
#' @return Returns nothing but gives a message if only one GPU is available.
#' @export
has_multiple_gpu_skip <- function() {
    gpuCheck <- try(detectGPUs(), silent=TRUE)
    if(class(gpuCheck)[1] == "try-error"){
        testthat::skip("No GPUs available")
    }else{
        if (gpuCheck < 2) {
            testthat::skip("Only one GPU available")
        }
    }
}

# check if any CPUs can be found
#' @title Skip test for CPUs
#' @description Function to skip testthat tests
#' if no valid CPU's are detected
#' @return Returns nothing but gives a message if no CPU is available.
#' @export
has_cpu_skip <- function() {
    cpuCheck <- try(detectCPUs(), silent=TRUE)
    if(class(cpuCheck)[1] == "try-error"){
        testthat::skip("No CPUs available")
    }else{
        if (cpuCheck == 0) {
            testthat::skip("No CPUs available")
        }
    }
}

# check if GPU supports double precision
#' @title Skip test for GPU double precision
#' @description Function to skip testthat tests
#' if the detected GPU doesn't support double precision
#' @return Returns nothing but gives a message if GPU doesn't support double precision.
#' @export
has_double_skip <- function() {
    deviceCheck <- try(deviceHasDouble(), silent=TRUE)
    if(class(deviceCheck)[1] == "try-error"){
        testthat::skip("Default device doesn't have double precision")
    }else{
        if (!deviceCheck) {
            testthat::skip("Default device doesn't support double precision")
        }
    }
}

# check if multiple GPUs supports double precision
#' @title Skip test for multiple GPUs with double precision
#' @description Function to skip testthat tests
#' if their aren't multiple detected GPU with double precision
#' @return Returns nothing but gives a message if there are less than 2 GPUs with double precision.
#' @export
has_multiple_double_skip <- function() {
    
    contexts <- listContexts()
    Sgpu = which(contexts$device_type ==  'gpu')
    contextsGpu = contexts[Sgpu, , drop=FALSE]
    
    gpus_with_double = sum(unlist(mapply(function(device_index, context) {
      gpuInfo(device_index + 1L, context)$double_support
    },
    device_index = contextsGpu$device_index, 
    context = contextsGpu$context)))

    if(gpus_with_double < 2){
        testthat::skip("Less than 2 GPUs with double precision")
    }
}


#' @title Set Context for Specific Device Type
#' @description This function find the first context
#' that contains a device of the specified type.
#' @param type A character vector specifying device type
#' @return An integer indicating previous context index
#' @importFrom utils head
#' @export
set_device_context <- function(type){
    
    current_context <- currentContext()
    if(deviceType() != type){
        contexts <- listContexts()
        cpus <- contexts[contexts$device_type == type,"context"]
        if(length(cpus) == 0){
            testthat::skip("No CPUs available")
        }else{
            
        }
        setContext(head(cpus, 1))
    }
    return(current_context)
}


#' @title POCL Version Check
#' @description Versions of POCL up to 0.15-pre have a bug
#' which results in values being returned when NA values
#' should be (e.g. fractional powers of negative values)
#' @return Returns nothing but gives a message if the POCL version is too old.
#' @export
pocl_check <- function(){
    p <- platformInfo()
    
    if(p$platformName == "Portable Computing Language"){
        v <- p$platformVersion
        v_split <- unlist(strsplit(v, "pocl"))
        v_sub <- v_split[length(v_split)]
        version <- as.numeric(regmatches(v_sub, regexpr("[0-9]\\d*(\\.\\d+)?", v_sub)))
        
        if(version <= 0.15){
            testthat::skip("pocl version too old")
        }
    }
    
}
