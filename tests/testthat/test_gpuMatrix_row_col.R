library(gpuR)
context("gpuMatrix Row and Column Methods")

if(detectGPUs() >= 1){
    current_context <- set_device_context("gpu")    
}else{
    current_context <- currentContext()
}

# set seed
set.seed(123)

ORDER_X <- 4
ORDER_Y <- 5

# Base R objects
A <- matrix(rnorm(ORDER_X*ORDER_Y), nrow=ORDER_X, ncol=ORDER_Y)
B <- matrix(rnorm(ORDER_X*ORDER_Y), nrow=ORDER_X, ncol=ORDER_Y)
Aint <- matrix(seq.int(ORDER_X), ORDER_X, ORDER_X)
Bint <- matrix(seq.int(ORDER_X), ORDER_X, ORDER_X)

R <- rowSums(A)
C <- colSums(A)
RM <- rowMeans(A)
CM <- colMeans(A)

RS <- rowSums(A[2:4, 2:4])
CS <- colSums(A[2:4, 2:4])
RMS <- rowMeans(A[2:4, 2:4])
CMS <- colMeans(A[2:4, 2:4])

S <- sum(A)

# gpuMatrix tests


test_that("gpuMatrix Integer Precision Sum",
{
  
  has_gpu_skip()
  
  fgpuX <- gpuMatrix(Aint, type="integer")
  
  gpuC <- sum(fgpuX)
  
  expect_is(gpuC, "integer")
  expect_equivalent(gpuC[], sum(Aint), 
                    info="integer sum not equivalent")  
})

test_that("gpuMatrix Single Precision Sum",
{
  has_gpu_skip()
  
  fgpuX <- gpuMatrix(A, type="float")
  
  gpuC <- sum(fgpuX)
  
  expect_is(gpuC, "numeric")
  expect_equal(gpuC[], sum(A), tolerance=1e-06, 
               info="float sum not equivalent")  
})

test_that("gpuMatrix Double Precision Sum", 
{
  has_gpu_skip()
  has_double_skip()

  dgpuX <- gpuMatrix(A, type="double")
  
  gpuC <-sum(dgpuX)
  
  expect_is(gpuC, "numeric")
  expect_equal(gpuC[], sum(A), tolerance=.Machine$double.eps ^ 0.5, 
               info="double sum not equivalent")  
})

test_that("gpuMatrix Single Precision Sum",
{
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    
    gpuS <- sum(fgpuX)
    
    expect_equal(gpuS, S, tolerance=1e-06, 
                 info="float sum value not equivalent")  
})


test_that("gpuMatrix Double Precision Sum",
{
    has_gpu_skip()
    has_double_skip()
    
    fgpuX <- gpuMatrix(A, type="double")
    
    gpuS <- sum(fgpuX)
    
    expect_equal(gpuS, S, tolerance=.Machine$double.eps^0.5, 
                 info="double sum value not equivalent")  
})

test_that("gpuMatrix Single Precision Column Sums",
{
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    
    gpuC <- colSums(fgpuX)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], C, tolerance=1e-06, 
                 info="float colSums not equivalent")  
})

test_that("gpuMatrix Double Precision Column Sums", 
{
    
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    
    gpuC <- colSums(dgpuX)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], C, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double colSums not equivalent")  
})


test_that("gpuMatrix Single Precision Row Sums",
{
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    
    gpuC <- rowSums(fgpuX)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], R, tolerance=1e-06, 
                 info="float rowSums not equivalent")  
})

test_that("gpuMatrix Double Precision Row Sums", 
{
    
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    
    gpuC <- rowSums(dgpuX)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], R, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double colSums not equivalent")  
})

test_that("gpuMatrix Single Precision Column Means",
{
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    
    gpuC <- colMeans(fgpuX)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], CM, tolerance=1e-06, 
                 info="float colMeans not equivalent")  
})

test_that("gpuMatrix Double Precision Column Means", 
{
    
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    
    gpuC <- colMeans(dgpuX)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], CM, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double colMeans not equivalent")  
})


test_that("gpuMatrix Single Precision Row Means",
{
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    
    gpuC <- rowMeans(fgpuX)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], RM, tolerance=1e-06, 
                 info="float rowMeans not equivalent")  
})

test_that("gpuMatrix Double Precision Row Means", 
{
    
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    
    gpuC <- rowMeans(dgpuX)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], RM, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double rowMeans not equivalent")  
})


#cbind/rbind tests
test_that("gpuMatrix Single Precision cbind",
{
    has_gpu_skip()
    
    C_bind <- cbind(A, B)
    C_scalar <- cbind(1, A)
    C_scalar2 <- cbind(A,1)
    
    gpuA <- gpuMatrix(A, type="float")
    gpuB <- gpuMatrix(B, type="float")
    
    gpuC <- cbind(gpuA, gpuB)
    
    expect_is(gpuC, "fgpuMatrix")
    expect_equal(gpuC[], C_bind, tolerance=1e-06, 
                 info="float cbind not equivalent")  
    
    gpu_scalar <- cbind(1, gpuA)
    gpu_scalar2 <- cbind(gpuA, 1)
    
    expect_equal(gpu_scalar[], C_scalar, tolerance=1e-06, 
                 info="float scalar cbind not equivalent") 
    expect_equal(gpu_scalar2[], C_scalar2, tolerance=1e-06, 
                 info="float scalar cbind not equivalent") 
})

test_that("gpuMatrix Double Precision cbind",
{
    has_gpu_skip()
    has_double_skip()
    
    C_bind <- cbind(A, B)
    C_scalar <- cbind(1, A)
    C_scalar2 <- cbind(A,1)
    
    gpuA <- gpuMatrix(A, type="double")
    gpuB <- gpuMatrix(B, type="double")
    
    gpuC <- cbind(gpuA, gpuB)
    
    expect_is(gpuC, "dgpuMatrix")
    expect_equal(gpuC[], C_bind, tolerance=.Machine$double.eps^0.5, 
                 info="double cbind not equivalent")  
    
    gpu_scalar <- cbind(1, gpuA)
    gpu_scalar2 <- cbind(gpuA, 1)
    
    expect_equal(gpu_scalar[], C_scalar, tolerance=.Machine$double.eps^0.5, 
                 info="double scalar cbind not equivalent") 
    expect_equal(gpu_scalar2[], C_scalar2, tolerance=.Machine$double.eps^0.5, 
                 info="double scalar cbind not equivalent") 
})

test_that("gpuMatrix Single Precision rbind",
{
    has_gpu_skip()
    
    C_bind <- rbind(A, B)
    C_scalar <- rbind(1, A)
    C_scalar2 <- rbind(A,1)
    
    gpuA <- gpuMatrix(A, type="float")
    gpuB <- gpuMatrix(B, type="float")
    
    gpuC <- rbind(gpuA, gpuB)
    
    expect_is(gpuC, "fgpuMatrix")
    expect_equal(gpuC[], C_bind, tolerance=1e-06, 
                 info="float rbind not equivalent")  
    
    gpu_scalar <- rbind(1, gpuA)
    gpu_scalar2 <- rbind(gpuA, 1)
    
    expect_equal(gpu_scalar[], C_scalar, tolerance=1e-06, 
                 info="float scalar rbind not equivalent") 
    expect_equal(gpu_scalar2[], C_scalar2, tolerance=1e-06, 
                 info="float scalar rbind not equivalent") 
})

test_that("gpuMatrix Double Precision rbind",
{
    has_gpu_skip()
    has_double_skip()
    
    C_bind <- rbind(A, B)
    C_scalar <- rbind(1, A)
    C_scalar2 <- rbind(A,1)
    
    gpuA <- gpuMatrix(A, type="double")
    gpuB <- gpuMatrix(B, type="double")
    
    gpuC <- rbind(gpuA, gpuB)
    
    expect_is(gpuC, "dgpuMatrix")
    expect_equal(gpuC[], C_bind, tolerance=.Machine$double.eps^0.5, 
                 info="double rbind not equivalent")  
    
    gpu_scalar <- rbind(1, gpuA)
    gpu_scalar2 <- rbind(gpuA, 1)
    
    expect_equal(gpu_scalar[], C_scalar, tolerance=.Machine$double.eps^0.5, 
                 info="double scalar rbind not equivalent") 
    expect_equal(gpu_scalar2[], C_scalar2, tolerance=.Machine$double.eps^0.5, 
                 info="double scalar rbind not equivalent") 
})

test_that("gpuMatrix Integer Precision cbind", {
    
    has_gpu_skip()
    
    C_bind <- cbind(Aint, Bint)
    C_scalar <- cbind(1, Aint)
    C_scalar2 <- cbind(Aint, 1)
    
    gpuA <- gpuMatrix(Aint, type="integer")
    gpuB <- gpuMatrix(Bint, type="integer")
    
    gpuC <- cbind(gpuA, gpuB)
    
    expect_is(gpuC, "igpuMatrix")
    expect_equal(gpuC[], C_bind,
                 info="integer cbind not equivalent")  
    
    gpu_scalar <- cbind(1L, gpuA)
    gpu_scalar2 <- cbind(gpuA, 1L)
    
    expect_equal(gpu_scalar[], C_scalar, 
                 info="integer scalar cbind not equivalent") 
    expect_equal(gpu_scalar2[], C_scalar2,
                 info="integer scalar cbind not equivalent") 
})

test_that("gpuMatrix Integer Precision rbind", {
    
    has_gpu_skip()
    
    C_bind <- rbind(Aint, Bint)
    C_scalar <- rbind(1, Aint)
    C_scalar2 <- rbind(Aint,1)
    
    gpuA <- gpuMatrix(Aint, type="integer")
    gpuB <- gpuMatrix(Bint, type="integer")
    
    gpuC <- rbind(gpuA, gpuB)
    
    expect_is(gpuC, "igpuMatrix")
    expect_equal(gpuC[], C_bind, 
                 info="integer rbind not equivalent")  
    
    gpu_scalar <- rbind(1L, gpuA)
    gpu_scalar2 <- rbind(gpuA, 1L)
    
    expect_equal(gpu_scalar[], C_scalar,
                 info="integer scalar rbind not equivalent") 
    expect_equal(gpu_scalar2[], C_scalar2,
                 info="integer scalar rbind not equivalent") 
})

# 'block' object tests
test_that("gpuMatrix Single Precision Block Sum",
{
  has_gpu_skip()
  
  fgpuX <- gpuMatrix(A, type="float")
  fgpuXS <- block(fgpuX, 2L,4L,2L,4L)
  
  gpuC <- sum(fgpuXS)
  
  expect_is(gpuC, "numeric")
  expect_equal(gpuC[], sum(A[2:4, 2:4]), tolerance=1e-06, 
               info="float sum not equivalent")  
})

test_that("gpuMatrix Double Precision Block Sum", 
{
  
  has_gpu_skip()
  has_double_skip()
  
  dgpuX <- gpuMatrix(A, type="double")
  dgpuXS <- block(dgpuX, 2L,4L,2L,4L)
  
  gpuC <- sum(dgpuXS)
  
  expect_is(gpuC, "numeric")
  expect_equal(gpuC[], sum(A[2:4,2:4]), tolerance=.Machine$double.eps ^ 0.5, 
               info="double colSums not equivalent")  
})

test_that("gpuMatrix Single Precision Block Column Sums", {
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    fgpuXS <- block(fgpuX, 2L,4L,2L,4L)
    
    gpuC <- colSums(fgpuXS)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], CS, tolerance=1e-06, 
                 info="float colSums not equivalent")  
})

test_that("gpuMatrix Double Precision Block Column Sums", 
{
    
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    dgpuXS <- block(dgpuX, 2L,4L,2L,4L)
    
    gpuC <- colSums(dgpuXS)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], CS, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double colSums not equivalent")  
})


test_that("gpuMatrix Single Precision Block Row Sums",
{
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    fgpuXS <- block(fgpuX, 2L,4L,2L,4L)
    
    gpuC <- rowSums(fgpuXS)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], RS, tolerance=1e-06, 
                 info="float rowSums not equivalent")  
})

test_that("gpuMatrix Double Precision Block Row Sums", 
{
    
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    dgpuXS <- block(dgpuX, 2L,4L,2L,4L)
    
    gpuC <- rowSums(dgpuXS)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], RS, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double colSums not equivalent")  
})

test_that("gpuMatrix Single Precision Block Column Means",
{
    
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    fgpuXS <- block(fgpuX, 2L,4L,2L,4L)
    
    gpuC <- colMeans(fgpuXS)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], CMS, tolerance=1e-06, 
                 info="float colMeans not equivalent")  
})

test_that("gpuMatrix Double Precision Block Column Means", 
{
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    dgpuXS <- block(dgpuX, 2L,4L,2L,4L)
    
    gpuC <- colMeans(dgpuXS)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], CMS, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double colMeans not equivalent")  
})


test_that("gpuMatrix Single Precision Block Row Means",
{
    has_gpu_skip()
    
    fgpuX <- gpuMatrix(A, type="float")
    fgpuXS <- block(fgpuX, 2L,4L,2L,4L)
    
    gpuC <- rowMeans(fgpuXS)
    
    expect_is(gpuC, "fgpuVector")
    expect_equal(gpuC[], RMS, tolerance=1e-06, 
                 info="float rowMeans not equivalent")  
})

test_that("gpuMatrix Double Precision Block Row Means", 
{
    has_gpu_skip()
    has_double_skip()
    
    dgpuX <- gpuMatrix(A, type="double")
    dgpuXS <- block(dgpuX, 2L,4L,2L,4L)
    
    gpuC <- rowMeans(dgpuXS)
    
    expect_is(gpuC, "dgpuVector")
    expect_equal(gpuC[], RMS, tolerance=.Machine$double.eps ^ 0.5, 
                 info="double rowMeans not equivalent")  
})

setContext(current_context)

