library(gpuR)
context("vclVector algebra")

if(detectGPUs() >= 1){
    current_context <- set_device_context("gpu")    
}else{
    current_context <- currentContext()
}

# set seed
set.seed(123)

ORDER <- 4

# Base R objects
Aint <- seq.int(10)
Bint <- sample(seq.int(10), ORDER)
A <- rnorm(ORDER)
B <- rnorm(ORDER)
E <- rnorm(ORDER-1)
D <- rnorm(ORDER + 1)

# Single Precision Tests

test_that("vclVector Single Precision Vector Addition ", {
    
    has_gpu_skip()
    
    C <- A + B
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    
    fvclC <- fvclA + fvclB
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vcl vector elements not equivalent")  
})

test_that("vclVector Single Precision Scalar Addition", {
    
    has_gpu_skip()
    
    C <- A + 1
    C2 <- 1 + A
    
    fvclA <- vclVector(A, type="float")
    
    fvclC <- fvclA + 1
    fvclC2 <- 1 + fvclA
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
    expect_is(fvclC2, "fvclVector")
    expect_equal(fvclC2[,], C2, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
})

test_that("vclVector Single Precision Vector Subtraction ", {
    
    has_gpu_skip()
    
    C <- A - B
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    
    fvclC <- fvclA - fvclB
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vcl vector elements not equivalent")  
})

test_that("gpuVector Single Precision Scalar Matrix Subtraction", {
    
    has_gpu_skip()
    
    C <- A - 1
    C2 <- 1 - A
    
    fvclA <- vclVector(A, type="float")
    
    fvclC <- fvclA - 1    
    fvclC2 <- 1 - fvclA
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
    expect_is(fvclC2, "fvclVector")
    expect_equal(fvclC2[,], C2, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
})

test_that("vclVector Single Precision Unary Vector Subtraction", {
    
    has_gpu_skip()
    
    C <- -A
    
    fvclA <- vclVector(A, type="float")
    
    fvclC <- -fvclA
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
})

test_that("vclVector Single Precision Vector Element-Wise Multiplication", {
    
    has_gpu_skip()
    
    C <- A * B
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    fvclE <- vclVector(E, type="float")
    
    fvclC <- fvclA * fvclB
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vcl vector elements not equivalent")  
    expect_error(fvclA * fvclE)
})

test_that("vclVector Single Precision Scalar Vector Multiplication", {
    
    has_gpu_skip()
    
    C <- A * 2
    C2 <- 2 * A
    
    dvclA <- vclVector(A, type="float")
    
    dvclC <- dvclA * 2
    dvclC2 <- 2 * dvclA
    
    expect_is(dvclC, "fvclVector")
    expect_equal(dvclC[,], C, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
    expect_is(dvclC2, "fvclVector")
    expect_equal(dvclC2[,], C2, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
})

test_that("vclVector Single Precision Vector Element-Wise Division", {
    
    has_gpu_skip()
    
    C <- A / B
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    fvclE <- vclVector(E, type="float")
    
    fvclC <- fvclA / fvclB
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vcl vector elements not equivalent")  
    expect_error(fvclA * fvclE)
})

test_that("vclVector Single Precision Scalar Division", {
    
    has_gpu_skip()
    
    C <- A/2
    C2 <- 2/A
    
    dvclA <- vclVector(A, type="float")
    
    dvclC <- dvclA/2
    dvclC2 <- 2/dvclA
    
    expect_is(dvclC, "fvclVector")
    expect_equal(dvclC[,], C, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
    expect_is(dvclC2, "fvclVector")
    expect_equal(dvclC2[,], C2, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
})

test_that("vclVector Single Precision Vector Element-Wise Power", {
    
    has_gpu_skip()
    
    C <- A ^ B
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    fvclE <- vclVector(E, type="float")
    
    fvclC <- fvclA ^ fvclB
    
    expect_is(fvclC, "fvclVector")
    expect_equal(fvclC[,], C, tolerance=1e-06, 
                 info="float vcl vector elements not equivalent")  
    expect_error(fvclA * fvclE)
})

test_that("vclVector Single Precision Scalar Power", {
    
    has_gpu_skip()
    
    C <- A^2
    C2 <- 2^A
    
    dvclA <- vclVector(A, type="float")
    
    dvclC <- dvclA^2
    dvclC2 <- 2^dvclA
    
    expect_is(dvclC, "fvclVector")
    expect_equal(dvclC[,], C, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
    expect_is(dvclC2, "fvclVector")
    expect_equal(dvclC2[,], C2, tolerance=1e-07, 
                 info="float vector elements not equivalent") 
})

test_that("vclVector Single Precision Inner Product ", {
    
    has_gpu_skip()
    
    C <- A %*% B
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    
    fvclC <- fvclA %*% fvclB
    
    expect_is(fvclC, "matrix")
    expect_equal(fvclC, C, tolerance=1e-06, 
                 info="float vcl vector elements not equivalent")  
})

test_that("vclVector Single Precision Outer Product ", {
    
    has_gpu_skip()
    
    C <- A %o% B
    C2 <- A %o% D
    
    fvclA <- vclVector(A, type="float")
    fvclB <- vclVector(B, type="float")
    fvclD <- vclVector(D, type="float")
    
    fvclC <- fvclA %o% fvclB
    fvclC2 <- fvclA %o% fvclD
    
    expect_is(fvclC, "fvclMatrix")
    expect_is(fvclC2, "fvclMatrix")
    expect_equal(fvclC[,], C, tolerance=1e-07, 
                 info="float vcl vector elements not equivalent")  
    expect_equal(fvclC2[,], C2, tolerance=1e-07,
                 info="float vcl vector elements not equivlanet")
})

test_that("vclVector Single precision tcrossprod", {
    
    has_gpu_skip()
    
    C <- tcrossprod(A,B)
    C2 <- tcrossprod(A)
    
    gpuA <- vclVector(A, type="float")
    gpuB <- vclVector(B, type="float")
    
    gpuC <- tcrossprod(gpuA, gpuB)
    gpuC2 <- tcrossprod(gpuA)
    
    expect_is(gpuC, "fvclMatrix")
    expect_is(gpuC2, "fvclMatrix")
    expect_equal(gpuC[], C, tolerance=1e-06, 
                 info="float vector outer product elements not equivalent")
    expect_equal(gpuC2[,], C2, tolerance=1e-06,
                 info="float vector outer product elements not equivalent")
})

# Double Precision Tests

test_that("vclVector Double Precision Vector Addition ", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A + B
    
    dvclA <- vclVector(A, type="double")
    dvclB <- vclVector(B, type="double")
    
    dvclC <- dvclA + dvclB
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vcl vector elements not equivalent")  
})

test_that("vclVector Double Precision Scalar Addition", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A + 1
    C2 <- 1 + A
    
    fvclA <- vclVector(A, type="double")
    
    fvclC <- fvclA + 1
    fvclC2 <- 1 + fvclA
    
    expect_is(fvclC, "dvclVector")
    expect_equal(fvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
    expect_is(fvclC2, "dvclVector")
    expect_equal(fvclC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
})

test_that("vclVector Double Precision Vector Subtraction ", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A - B
    
    dvclA <- vclVector(A, type="double")
    dvclB <- vclVector(B, type="double")
    
    dvclC <- dvclA - dvclB
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vcl vector elements not equivalent")  
})

test_that("vclVector Double Precision Scalar Matrix Subtraction", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A - 1
    C2 <- 1 - A
    
    fvclA <- vclVector(A, type="double")
    
    fvclC <- fvclA - 1    
    fvclC2 <- 1 - fvclA
    
    expect_is(fvclC, "dvclVector")
    expect_equal(fvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
    expect_is(fvclC2, "dvclVector")
    expect_equal(fvclC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
})

test_that("vclVector Double Precision Unary Vector Subtraction", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- -A
    
    fvclA <- vclVector(A, type="double")
    
    fvclC <- -fvclA
    
    expect_is(fvclC, "dvclVector")
    expect_equal(fvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
})

test_that("vclVector Double Precision Vector Element-Wise Multiplication", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A * B
    
    dvclA <- vclVector(A, type="double")
    dvclB <- vclVector(B, type="double")
    dvclE <- vclVector(E, type="double")
    
    dvclC <- dvclA * dvclB
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vcl vector elements not equivalent")  
    expect_error(dvclA * dvclE)
})

test_that("vclVector Double Precision Scalar Multiplication", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A * 2
    C2 <- 2 * A
    
    dvclA <- vclVector(A, type="double")
    
    dvclC <- dvclA * 2
    dvclC2 <- 2 * dvclA
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
    expect_is(dvclC2, "dvclVector")
    expect_equal(dvclC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
})

test_that("vclVector Double Precision Vector Element-Wise Division", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A / B
    
    dvclA <- vclVector(A, type="double")
    dvclB <- vclVector(B, type="double")
    dvclE <- vclVector(E, type="double")
    
    dvclC <- dvclA / dvclB
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vcl vector elements not equivalent")  
    expect_error(dvclA * dvclE)
})

test_that("vclVector Double Precision Scalar Division", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A/2
    C2 <- 2/A
    
    dvclA <- vclVector(A, type="double")
    
    dvclC <- dvclA/2
    dvclC2 <- 2/dvclA
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
    expect_is(dvclC2, "dvclVector")
    expect_equal(dvclC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
})

test_that("vclVector Double Precision Vector Element-Wise Power", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A ^ B
    
    fvclA <- vclVector(A, type="double")
    fvclB <- vclVector(B, type="double")
    fvclE <- vclVector(E, type="double")
    
    fvclC <- fvclA ^ fvclB
    
    expect_is(fvclC, "dvclVector")
    expect_equal(fvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent")  
    expect_error(fvclA * fvclE)
})

test_that("vclVector Double Precision Scalar Power", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A^2
    C2 <- 2^A
    
    dvclA <- vclVector(A, type="double")
    
    dvclC <- dvclA^2
    dvclC2 <- 2^dvclA
    
    expect_is(dvclC, "dvclVector")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
    expect_is(dvclC2, "dvclVector")
    expect_equal(dvclC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vector elements not equivalent") 
})

test_that("vclVector Double Precision Inner Product ", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A %*% B
    
    dvclA <- vclVector(A, type="double")
    dvclB <- vclVector(B, type="double")
    
    dvclC <- dvclA %*% dvclB
    
    expect_is(dvclC, "matrix")
    expect_equal(dvclC, C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vcl vector elements not equivalent")  
})

test_that("vclVector Double Precision Outer Product ", {
    
    has_gpu_skip()
    has_double_skip()
    
    C <- A %o% B
    C2 <- A %o% D
    
    dvclA <- vclVector(A, type="double")
    dvclB <- vclVector(B, type="double")
    dvclD <- vclVector(D, type="double")
    
    dvclC <- dvclA %o% dvclB
    dvclC2 <- dvclA %o% dvclD
    
    expect_is(dvclC, "dvclMatrix")
    expect_is(dvclC2, "dvclMatrix")
    expect_equal(dvclC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double vcl vector elements not equivalent")  
    expect_equal(dvclC2[,], C2, tolerance=.Machine$double.eps^0.5,
                 info="double vcl vector elements not equivalent")
})

test_that("vclVector Double precision tcrossprod", {
    
    has_gpu_skip()
    has_double_skip()

    C <- tcrossprod(A,B)
    C2 <- tcrossprod(A)
    
    gpuA <- vclVector(A, type="double")
    gpuB <- vclVector(B, type="double")
    
    gpuC <- tcrossprod(gpuA, gpuB)
    gpuC2 <- tcrossprod(gpuA)
    
    expect_is(gpuC, "dvclMatrix")
    expect_is(gpuC2, "dvclMatrix")
    expect_equal(gpuC[], C, tolerance=1e-06, 
                 info="double vector outer product elements not equivalent")
    expect_equal(gpuC2[,], C2, tolerance=1e-06,
                 info="double vector outer product elements not equivalent")
})

setContext(current_context)
