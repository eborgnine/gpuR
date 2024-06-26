library(gpuR)
context("CPU gpuMatrix algebra")

current_context <- set_device_context("cpu")

# set seed
set.seed(123)

ORDER <- 4
ORDER_PAD <- 129

# Base R objects
Aint <- matrix(sample(seq(10), ORDER^2, replace=TRUE), nrow=ORDER, ncol=ORDER)
Bint <- matrix(sample(seq(10), ORDER^2, replace=TRUE), nrow=ORDER, ncol=ORDER)
AintPad <- matrix(sample(seq(10), ORDER*ORDER_PAD, replace=TRUE), nrow=ORDER, ncol=ORDER_PAD)
BintPad <- matrix(sample(seq(10), ORDER*ORDER_PAD, replace=TRUE), nrow=ORDER_PAD, ncol = ORDER)
A <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
B <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
E <- matrix(rnorm(15), nrow=5)
v <- rnorm(ORDER)

# Single Precision tests
test_that("CPU gpuMatrix Single Precision Matrix multiplication", {
    
    has_cpu_skip()
    
    C <- A %*% B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuE <- gpuMatrix(E, type = "float")
    
    fgpuC <- fgpuA %*% fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_error(fgpuA %*% fgpuE,
                 info = "error not thrown for non-conformant matrices")
    
    fgpuC <- A %*% fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- fgpuA %*% B
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Matrix-Vector multiplication", {
    
    has_cpu_skip()
    
    C <- A %*% v
    C2 <- v %*% B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuV <- gpuVector(v, type = "float")
    
    fgpuC <- fgpuA %*% fgpuV
    fgpuC2 <- fgpuV %*% fgpuB
    
    expect_equal(fgpuC[,], c(C), tolerance=1e-06, 
                 info="float matrix elements not equivalent")  
    expect_equal(fgpuC2[,], c(C2), tolerance=1e-06, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Matrix Subtraction", {
    
    has_cpu_skip()
    
    C <- A - B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuE <- gpuMatrix(E, type="float")
    
    fgpuC <- fgpuA - fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_error(fgpuA - fgpuE)
    
    fgpuC <- fgpuA - B
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- A - fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Matrix/Vector Subtraction", {
    
    has_cpu_skip()
    
    C <- A - c(B)
    C2 <- c(A) - B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuVector(c(B), type="float")
    
    fgpuC <- fgpuA - fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuA <- gpuVector(c(A), type="float")
    fgpuB <- gpuMatrix(B, type="float")
    
    fgpuC <- fgpuA - fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C2, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
})

test_that("CPU gpuMatrix Single Precision Scalar Matrix Subtraction", {
    
    has_cpu_skip()
    
    C <- A - 1
    C2 <- 1 - A
    
    fgpuA <- gpuMatrix(A, type="float")
    
    fgpuC <- fgpuA - 1    
    fgpuC2 <- 1 - fgpuA
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_is(fgpuC2, "fgpuMatrix")
    expect_equal(fgpuC2[,], C2, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision Unary Scalar Matrix Subtraction", {
    
    has_cpu_skip()
    
    C <- -A
    
    fgpuA <- gpuMatrix(A, type="float")
    
    fgpuC <- -fgpuA
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision Matrix Addition", {
    
    has_cpu_skip()
    
    C <- A + B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuE <- gpuMatrix(E, type="float")
    
    fgpuC <- fgpuA + fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_error(fgpuA + fgpuE)
    
    fgpuC <- A + fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- fgpuA + B
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Matrix/Vector Addition", {
    
    has_cpu_skip()
    
    C <- A + c(B)
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuVector(c(B), type="float")
    
    fgpuC <- fgpuA + fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuA <- gpuVector(c(A), type="float")
    fgpuB <- gpuMatrix(B, type="float")
    
    fgpuC <- fgpuA + fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
})

test_that("CPU gpuMatrix Single Precision Scalar Matrix Addition", {
    
    has_cpu_skip()
    
    C <- A + 1
    C2 <- 1 + A
    
    fgpuA <- gpuMatrix(A, type="float")
    
    fgpuC <- fgpuA + 1
    fgpuC2 <- 1 + fgpuA
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_is(fgpuC2, "fgpuMatrix")
    expect_equal(fgpuC2[,], C2, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision Matrix Element-Wise Multiplication", {
    
    has_cpu_skip()
    
    C <- A * B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuE <- gpuMatrix(E, type="float")
    
    fgpuC <- fgpuA * fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_error(fgpuA * fgpuE)
    
    fgpuC <- A * fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- fgpuA * B
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Scalar Matrix Multiplication", {
    
    has_cpu_skip()
    
    C <- A * 2
    C2 <- 2 * A
    
    dgpuA <- gpuMatrix(A, type="float")
    
    dgpuC <- dgpuA * 2
    dgpuC2 <- 2 * dgpuA
    
    expect_is(dgpuC, "fgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_is(dgpuC2, "fgpuMatrix")
    expect_equal(dgpuC2[,], C2, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision Matrix Element-Wise Division", {
    
    has_cpu_skip()
    
    C <- A / B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuE <- gpuMatrix(E, type="float")
    
    fgpuC <- fgpuA / fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_error(fgpuA / fgpuE)
    
    fgpuC <- A / fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- fgpuA / B
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Scalar Matrix Division", {
    
    has_cpu_skip()
    
    C <- A/2
    C2 <- 2/A
    
    dgpuA <- gpuMatrix(A, type="float")
    
    dgpuC <- dgpuA/2
    dgpuC2 <- 2/dgpuA
    
    expect_is(dgpuC, "fgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_is(dgpuC2, "fgpuMatrix")
    expect_equal(dgpuC2[,], C2, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision Matrix Element-Wise Power", {
    
    has_cpu_skip()
    pocl_check()
    
    C <- A ^ B
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuB <- gpuMatrix(B, type="float")
    fgpuE <- gpuMatrix(E, type="float")
    
    fgpuC <- fgpuA ^ fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_error(fgpuA ^ fgpuE)
    
    fgpuC <- A ^ fgpuB
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- fgpuA ^ B
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision Scalar Matrix Power", {
    
    has_cpu_skip()
    
    C <- A^2
    C2 <- 2^A
    
    dgpuA <- gpuMatrix(A, type="float")
    
    dgpuC <- dgpuA^2
    dgpuC2 <- 2^dgpuA
    
    expect_is(dgpuC, "fgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_equal(dgpuC2[,], C2, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision crossprod", {
    
    has_cpu_skip()
    
    X <- matrix(rnorm(10), nrow=2)
    Y <- matrix(rnorm(10), nrow=2)
    Z <- matrix(rnorm(10), nrow=5)
    
    C <- crossprod(X,Y)
    Cs <- crossprod(X)
    
    fgpuX <- gpuMatrix(X, type="float")
    fgpuY <- gpuMatrix(Y, type="float")
    fgpuZ <- gpuMatrix(Z, type="float")
    
    fgpuC <- crossprod(fgpuX, fgpuY)
    fgpuCs <- crossprod(fgpuX)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_equal(fgpuCs[,], Cs, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_error(crossprod(fgpuX, fgpuZ))
    
    fgpuC <- crossprod(fgpuX, Y)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- crossprod(X, fgpuY)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision tcrossprod", {
    
    has_cpu_skip()
    
    X <- matrix(rnorm(10), nrow=2)
    Y <- matrix(rnorm(10), nrow=2)
    Z <- matrix(rnorm(12), nrow=2)
    
    C <- tcrossprod(X,Y)
    Cs <- tcrossprod(X)
    
    fgpuX <- gpuMatrix(X, type="float")
    fgpuY <- gpuMatrix(Y, type="float")
    fgpuZ <- gpuMatrix(Z, type="float")
    
    fgpuC <- tcrossprod(fgpuX, fgpuY)
    fgpuCs <- tcrossprod(fgpuX)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    expect_equal(fgpuCs[,], Cs, tolerance=1e-07, 
                 info="float matrix elements not equivalent") 
    expect_error(tcrossprod(fgpuX, fgpuZ))

    fgpuC <- tcrossprod(fgpuX, Y)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    fgpuC <- tcrossprod(X, fgpuY)
    
    expect_is(fgpuC, "fgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Single Precision transpose", {
    
    has_cpu_skip()
    
    At <- t(A)
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpuAt <- t(fgpuA)
    
    expect_is(fgpuAt, "fgpuMatrix")
    expect_equal(fgpuAt[,], At, tolerance=1e-07, 
                 info="transposed float matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Single Precision determinant", {
    
    has_cpu_skip()
    
    d <- det(A)
    
    fgpuA <- gpuMatrix(A, type="float")
    fgpud <- det(fgpuA)
    
    expect_is(fgpud, "numeric")
    expect_equal(fgpud, d, tolerance=1e-07, 
                 info="float determinants not equivalent") 
})

# Integer tests

test_that("CPU gpuMatrix Integer Matrix multiplication", {
    
    has_cpu_skip()
    
    Cint <- Aint %*% Bint
    CintPad <- AintPad %*% BintPad
    
    igpuA <- gpuMatrix(Aint, type="integer")
    igpuB <- gpuMatrix(Bint, type="integer")
    igpuApad <- gpuMatrix(AintPad, type="integer")
    igpuBpad <- gpuMatrix(BintPad, type="integer")
    
    igpuC <- igpuA %*% igpuB
    
    expect_equivalent(igpuC[,], Cint,
                      info="integer matrix elements not equivalent")
    
    igpuC <- Aint %*% igpuB
    
    expect_equivalent(igpuC[,], Cint,
                      info="integer matrix elements not equivalent")
    
    igpuC <- igpuA %*% Bint
    
    expect_equivalent(igpuC[,], Cint,
                      info="integer matrix elements not equivalent")
    
    igpuCpad <- igpuApad %*% igpuBpad
    
    expect_equivalent(igpuCpad[], CintPad,
                      info = "padded rectangular matrix elements not equivalent")
})

test_that("CPU gpuMatrix Integer Matrix Subtraction", {
    
    has_cpu_skip()
    
    Cint <- Aint - Bint
    
    igpuA <- gpuMatrix(Aint, type="integer")
    igpuB <- gpuMatrix(Bint, type="integer")
    
    igpuC <- igpuA - igpuB
    
    expect_is(igpuC, "igpuMatrix")
    expect_equal(igpuC[,], Cint,
                 info="integer matrix elements not equivalent")
    
    
    igpuC <- igpuA - Bint
    
    expect_is(igpuC, "igpuMatrix")
    expect_equal(igpuC[,], Cint,
                 info="integer matrix elements not equivalent")
    
    
    igpuC <- Aint - igpuB
    
    expect_is(igpuC, "igpuMatrix")
    expect_equal(igpuC[,], Cint,
                 info="integer matrix elements not equivalent")
})

test_that("CPU gpuMatrix Integer Precision Scalar Matrix Subtraction", {
    
    has_cpu_skip()
    
    C <- Aint - 1L
    C2 <- 1L - Aint
    
    fgpuA <- gpuMatrix(Aint, type="integer")
    
    fgpuC <- fgpuA - 1L
    fgpuC2 <- 1L - fgpuA
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C, 
                 info="integer matrix elements not equivalent") 
    expect_is(fgpuC2, "igpuMatrix")
    expect_equal(fgpuC2[,], C2,
                 info="intger matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Precision Unary Scalar Matrix Subtraction", {
    
    has_cpu_skip()
    
    C <- -Aint
    
    fgpuA <- gpuMatrix(Aint, type="integer")
    
    fgpuC <- -fgpuA
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Matrix Addition", {
    
    has_cpu_skip()
    
    Cint <- Aint + Bint
    
    igpuA <- gpuMatrix(Aint, type="integer")
    igpuB <- gpuMatrix(Bint, type="integer")
    
    igpuC <- igpuA + igpuB
    
    expect_is(igpuC, "igpuMatrix")
    expect_equal(igpuC[,], Cint,
                 info="integer matrix elements not equivalent")
    
    igpuC <- Aint + igpuB
    
    expect_is(igpuC, "igpuMatrix")
    expect_equal(igpuC[,], Cint,
                 info="integer matrix elements not equivalent")
    
    igpuC <- igpuA + Bint
    
    expect_is(igpuC, "igpuMatrix")
    expect_equal(igpuC[,], Cint,
                 info="integer matrix elements not equivalent")
})

test_that("CPU gpuMatrix Integer Precision Scalar Matrix Addition", {
    
    has_cpu_skip()
    
    C <- Aint + 1L
    C2 <- 1L + Aint
    
    fgpuA <- gpuMatrix(Aint, type="integer")
    
    fgpuC <- fgpuA + 1L
    fgpuC2 <- 1L + fgpuA
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent") 
    expect_is(fgpuC2, "igpuMatrix")
    expect_equal(fgpuC2[,], C2,
                 info="integer matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Precision Matrix Element-Wise Multiplication", {
    
    has_cpu_skip()
    
    C <- Aint * Bint
    
    fgpuA <- gpuMatrix(Aint, type="integer")
    fgpuB <- gpuMatrix(Bint, type="integer")
    
    fgpuC <- fgpuA * fgpuB
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C, 
                 info="integer matrix elements not equivalent") 
    
    fgpuC <- Aint * fgpuB
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C, 
                 info="integer matrix elements not equivalent") 
    
    fgpuC <- fgpuA * Bint
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C, 
                 info="integer matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Precision Scalar Matrix Multiplication", {
    
    has_cpu_skip()
    
    C <- Aint * 2L
    C2 <- 2L * Aint
    
    dgpuA <- gpuMatrix(Aint, type="integer")
    
    dgpuC <- dgpuA * 2L
    dgpuC2 <- 2L * dgpuA
    
    expect_is(dgpuC, "igpuMatrix")
    expect_equal(dgpuC[,], C,
                 info="integer matrix elements not equivalent") 
    expect_is(dgpuC2, "igpuMatrix")
    expect_equal(dgpuC2[,], C2,
                 info="integer matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Precision Matrix Element-Wise Division", {
    
    has_cpu_skip()
    
    C <- Aint / Bint
    C <- apply(C, 2, as.integer)
    
    fgpuA <- gpuMatrix(Aint, type="integer")
    fgpuB <- gpuMatrix(Bint, type="integer")
    
    fgpuC <- fgpuA / fgpuB
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent") 
    
    fgpuC <- Aint / fgpuB
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent") 
    
    fgpuC <- fgpuA / Bint
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Precision Scalar Matrix Division", {
    
    has_cpu_skip()
    
    C <- Aint/2L
    C2 <- 2L/Aint
    
    C <- apply(C, 2, as.integer)
    C2 <- apply(C2, 2, as.integer)
    
    dgpuA <- gpuMatrix(Aint, type="integer")
    
    dgpuC <- dgpuA/2L
    dgpuC2 <- 2L/dgpuA
    
    expect_is(dgpuC, "igpuMatrix")
    expect_equal(dgpuC[,], C,
                 info="integer matrix elements not equivalent") 
    expect_is(dgpuC2, "igpuMatrix")
    expect_equal(dgpuC2[,], C2,
                 info="integer matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Integer Precision Matrix Element-Wise Power", {
    
    has_cpu_skip()
    pocl_check()
    
    Apow <- matrix(seq.int(16), ncol=4, nrow=4)
    Bpow <- matrix(2, ncol = 4, nrow = 4)
    C <- Apow ^ Bpow
    
    fgpuA <- gpuMatrix(Apow, type="integer")
    fgpuB <- gpuMatrix(Bpow, type="integer")
    
    fgpuC <- fgpuA ^ fgpuB
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent")
    
    fgpuC <- Apow ^ fgpuB
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent")
    
    fgpuC <- fgpuA ^ Bpow
    
    expect_is(fgpuC, "igpuMatrix")
    expect_equal(fgpuC[,], C,
                 info="integer matrix elements not equivalent")
})

test_that("CPU gpuMatrix Integer Precision Scalar Matrix Power", {
    
    has_cpu_skip()
    
    C <- Aint^2L
    C2 <- 2L^Aint
    
    C <- apply(C, 2, as.integer)
    C2 <- apply(C2, 2, as.integer)
    
    dgpuA <- gpuMatrix(Aint, type="integer")
    
    dgpuC <- dgpuA^2L
    dgpuC2 <- 2L^dgpuA
    
    expect_is(dgpuC, "igpuMatrix")
    expect_equal(dgpuC[,], C,
                 info="integer matrix elements not equivalent")
    expect_equal(dgpuC2[,], C2,
                 info="integer matrix elements not equivalent")
})

# Double Precision tests

test_that("CPU gpuMatrix Double Precision Matrix multiplication", {
    
    has_cpu_skip()
    
    C <- A %*% B
    
    dgpuA <- gpuMatrix(A, type="double")
    dgpuB <- gpuMatrix(B, type="double")
    
    dgpuC <- dgpuA %*% dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    dgpuC <- dgpuA %*% B
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    dgpuC <- A %*% dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision Matrix-Vector multiplication", {
    
    has_cpu_skip()
    
    C <- A %*% v
    C2 <- v %*% B
    
    fgpuA <- gpuMatrix(A, type="double")
    fgpuB <- gpuMatrix(B, type="double")
    fgpuV <- gpuVector(v, type = "double")
    
    fgpuC <- fgpuA %*% fgpuV
    fgpuC2 <- fgpuV %*% fgpuB
    
    expect_equal(fgpuC[,], c(C), tolerance=.Machine$double.eps^0.5,
                 info="double matrix elements not equivalent")
    expect_equal(fgpuC2[,], c(C2), tolerance=.Machine$double.eps^0.5,
                 info="double matrix elements not equivalent")
})

test_that("CPU gpuMatrix Double Precision Matrix Subtraction", {
    
    has_cpu_skip()
    
    C <- A - B
    
    dgpuA <- gpuMatrix(A, type="double")
    dgpuB <- gpuMatrix(B, type="double")
    dgpuE <- gpuMatrix(E, type="double")
    
    dgpuC <- dgpuA - dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_error(dgpuA - dgpuE)
    
    dgpuC <- A - dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    dgpuC <- dgpuA - B
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision Matrix/Vector Subtraction", {
    
    has_cpu_skip()
    
    C <- A - c(B)
    C2 <- c(A) - B
    
    fgpuA <- gpuMatrix(A, type="double")
    fgpuB <- gpuVector(c(B), type="double")
    
    fgpuC <- fgpuA - fgpuB
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps^0.5, 
                 info="double matrix elements not equivalent")  
    
    fgpuA <- gpuVector(c(A), type="double")
    fgpuB <- gpuMatrix(B, type="double")
    
    fgpuC <- fgpuA - fgpuB
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C2, tolerance=.Machine$double.eps^0.5, 
                 info="double matrix elements not equivalent")  
    
})

test_that("CPU gpuMatrix Double Precision Matrix Addition", {
    
    has_cpu_skip()
    
    C <- A + B
    
    dgpuA <- gpuMatrix(A, type="double")
    dgpuB <- gpuMatrix(B, type="double")
    dgpuE <- gpuMatrix(E, type="double")
    
    dgpuC <- dgpuA + dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_error(dgpuA + dgpuE)
    
    dgpuC <- A + dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    dgpuC <- dgpuA + B
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision Matrix/Vector Addition", {
    
    has_cpu_skip()
    
    C <- A + c(B)
    
    fgpuA <- gpuMatrix(A, type="double")
    fgpuB <- gpuVector(c(B), type="double")
    
    fgpuC <- fgpuA + fgpuB
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps^0.5, 
                 info="double matrix elements not equivalent")  
    
    fgpuA <- gpuVector(c(A), type="double")
    fgpuB <- gpuMatrix(B, type="double")
    
    fgpuC <- fgpuA + fgpuB
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps^0.5, 
                 info="double matrix elements not equivalent")  
    
})

test_that("CPU gpuMatrix Double Precision Scalar Matrix Addition", {
    
    has_cpu_skip()
    
    
    C <- A + 1
    C2 <- 1 + A
    
    dgpuA <- gpuMatrix(A, type="double")
    
    dgpuC <- dgpuA + 1
    dgpuC2 <- 1 + dgpuA
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    expect_is(dgpuC2, "dgpuMatrix")
    expect_equal(dgpuC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision Scalar Matrix Subtraction", {
    
    has_cpu_skip()
    
    
    C <- A - 1
    C2 <- 1 - A
    
    dgpuA <- gpuMatrix(A, type="double")
    
    dgpuC <- dgpuA - 1
    dgpuC2 <- 1 - dgpuA
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    expect_is(dgpuC2, "dgpuMatrix")
    expect_equal(dgpuC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision Unary Matrix Subtraction", {
    
    has_cpu_skip()
    
    
    C <- -A
    
    fgpuA <- gpuMatrix(A, type="double")
    
    fgpuC <- -fgpuA
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision Matrix Element-Wise Multiplication", {
    
    has_cpu_skip()
    
    
    C <- A * B
    
    dgpuA <- gpuMatrix(A, type="double")
    dgpuB <- gpuMatrix(B, type="double")
    dgpuE <- gpuMatrix(E, type="double")
    
    dgpuC <- dgpuA * dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_error(dgpuA * dgpuE)
    
    dgpuC <- A * dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    
    dgpuC <- dgpuA * B
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision Scalar Matrix Multiplication", {
    
    has_cpu_skip()
    
    
    C <- A * 2
    C2 <- 2 * A
    
    dgpuA <- gpuMatrix(A, type="double")
    
    dgpuC <- dgpuA * 2
    dgpuC2 <- 2 * dgpuA
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    expect_is(dgpuC2, "dgpuMatrix")
    expect_equal(dgpuC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision Matrix Element-Wise Division", {
    
    has_cpu_skip()
    
    
    C <- A / B
    
    dgpuA <- gpuMatrix(A, type="double")
    dgpuB <- gpuMatrix(B, type="double")
    dgpuE <- gpuMatrix(E, type="double")
    
    dgpuC <- dgpuA / dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_error(dgpuA * dgpuE)
    
    dgpuC <- A / dgpuB
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    dgpuC <- dgpuA / B
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision Scalar Matrix Division", {
    
    has_cpu_skip()
    
    
    C <- A/2
    C2 <- 2/A
    
    dgpuA <- gpuMatrix(A, type="double")
    
    dgpuC <- dgpuA/2
    dgpuC2 <- 2/dgpuA
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    expect_is(dgpuC2, "dgpuMatrix")
    expect_equal(dgpuC2[,], C2, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision Matrix Element-Wise Power", {
    
    has_cpu_skip()
    pocl_check()
    
    
    C <- A ^ B
    
    fgpuA <- gpuMatrix(A, type="double")
    fgpuB <- gpuMatrix(B, type="double")
    fgpuE <- gpuMatrix(E, type="double")
    
    fgpuC <- fgpuA ^ fgpuB
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_error(fgpuA ^ fgpuE)
    
    fgpuC <- A ^ fgpuB
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    fgpuC <- fgpuA ^ B
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision Scalar Matrix Power", {
    
    has_cpu_skip()
    
    
    C <- A^2
    
    dgpuA <- gpuMatrix(A, type="double")
    
    dgpuC <- dgpuA^2
    
    expect_is(dgpuC, "dgpuMatrix")
    expect_equal(dgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision crossprod", {
    
    has_cpu_skip()
    
    X <- matrix(rnorm(10), nrow=2)
    Y <- matrix(rnorm(10), nrow=2)
    Z <- matrix(rnorm(10), nrow=5)
    
    C <- crossprod(X,Y)
    Cs <- crossprod(X)
    
    fgpuX <- gpuMatrix(X, type="double")
    fgpuY <- gpuMatrix(Y, type="double")
    fgpuZ <- gpuMatrix(Z, type="double")
    
    fgpuC <- crossprod(fgpuX, fgpuY)
    fgpuCs <- crossprod(fgpuX)
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_equal(fgpuCs[,], Cs, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    expect_error(crossprod(fgpuX, fgpuZ))
    
    fgpuC <- crossprod(fgpuX, Y)
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    fgpuC <- crossprod(X, fgpuY)
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision tcrossprod", {
    
    has_cpu_skip()
    
    X <- matrix(rnorm(10), nrow=2)
    Y <- matrix(rnorm(10), nrow=2)
    Z <- matrix(rnorm(12), nrow=2)
    
    C <- tcrossprod(X,Y)
    Cs <- tcrossprod(X)
    
    fgpuX <- gpuMatrix(X, type="double")
    fgpuY <- gpuMatrix(Y, type="double")
    fgpuZ <- gpuMatrix(Z, type="double")
    
    fgpuC <- tcrossprod(fgpuX, fgpuY)
    fgpuCs <- tcrossprod(fgpuX)
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    expect_equal(fgpuCs[,], Cs, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent") 
    expect_error(tcrossprod(fgpuX, fgpuZ))
    
    fgpuC <- tcrossprod(fgpuX, Y)
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
    
    fgpuC <- tcrossprod(X, fgpuY)
    
    expect_is(fgpuC, "dgpuMatrix")
    expect_equal(fgpuC[,], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double matrix elements not equivalent")  
})

test_that("CPU gpuMatrix Double Precision transpose", {
    
    has_cpu_skip()
    
    At <- t(A)
    
    fgpuA <- gpuMatrix(A, type="double")
    fgpuAt <- t(fgpuA)
    
    expect_is(fgpuAt, "dgpuMatrix")
    expect_equal(fgpuAt[,], At, tolerance=.Machine$double.eps^0.5, 
                 info="transposed double matrix elements not equivalent") 
})


test_that("CPU gpuMatrix Diagonal access", {
    
    has_cpu_skip()
    
    fgpuA <- gpuMatrix(A, type="float")
    
    D <- diag(A)
    gpuD <- diag(fgpuA)
        
    expect_is(gpuD, "fgpuVector")
    expect_equal(gpuD[,], D, tolerance=1e-07, 
                 info="float matrix diagonal elements not equivalent") 
    
    vec <- rnorm(ORDER)
    diag(fgpuA) <- gpuVector(vec, type = "float")
    diag(A) <- vec
    
    expect_equal(fgpuA[,], A, tolerance=1e-07, 
                 info="set float matrix diagonal elements not equivalent") 
    
    
    fgpuA <- gpuMatrix(A, type="double")
    
    D <- diag(A)
    gpuD <- diag(fgpuA)
    
    expect_is(gpuD, "dgpuVector")
    expect_equal(gpuD[,], D, tolerance=.Machine$double.eps^0.5, 
                 info="double matrix diagonal elements not equivalent")  
    
    vec <- rnorm(ORDER)
    diag(fgpuA) <- gpuVector(vec, type = "double")
    diag(A) <- vec
    
    expect_equal(fgpuA[,], A, tolerance=.Machine$double.eps^0.5, 
                 info="set double matrix diagonal elements not equivalent") 
})

test_that("CPU gpuMatrix Double Precision determinant", {
    
    has_cpu_skip()
    
    d <- det(A)
    
    fgpuA <- gpuMatrix(A, type="double")
    fgpud <- det(fgpuA)
    
    expect_is(fgpud, "numeric")
    expect_equal(fgpud, d, tolerance=.Machine$double.eps^0.5, 
                 info="double determinants not equivalent") 
})

setContext(current_context)

