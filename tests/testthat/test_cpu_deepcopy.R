library(gpuR)
testthat::context("CPU deepcopy")

current_context <- set_device_context("cpu")

# set seed
set.seed(123)

ORDER <- 4

# Base R objects
Aint <- matrix(sample(seq.int(10), ORDER^2, replace=TRUE), nrow=ORDER, ncol=ORDER)
A <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
Avec <- rnorm(ORDER)
AintVec <- seq.int(ORDER)

test_that("CPU Check Integer gpuVector deepcopy", {
    
    has_cpu_skip()
    
    gpuA <- gpuVector(AintVec)
    
    # deepcopy
    gpuB <- deepcopy(gpuA)
    
    expect_equal(gpuA, gpuB)
    expect_is(gpuB, "igpuVector")
    expect_is(gpuB, class(gpuA))
    expect_equal(gpuA[], gpuB[],
                 info="igpuVector deepcopy elements not equivalent")  
    
    gpuB[1] <- 42L    
    expect_false(isTRUE(all.equal(gpuA[], gpuB[])),
                 info = "igpuVector deepcopy not distinct from source")
})

test_that("CPU Check Single Precision gpuVector deepcopy", {
    
    has_cpu_skip()
    
    gpuA <- gpuVector(A, type="float")
    
    # deepcopy
    gpuB <- deepcopy(gpuA)
    
    expect_equal(gpuA, gpuB)
    expect_is(gpuB, class(gpuA))
    expect_equal(gpuA[], gpuB[], tolerance=1e-07, 
                 info="float deepcopy gpuVector elements not equivalent")  
    
    gpuB[1] <- 42
    expect_false(isTRUE(all.equal(gpuA[], gpuB[], tolerance = 1e-07)),
                 info = "fgpuVector deepcopy not distinct from source")
})

test_that("CPU Check Double Precision gpuVector deepcopy", {
    
    has_cpu_skip()

    gpuA <- gpuVector(A, type="double")
    
    # deepcopy
    gpuB <- deepcopy(gpuA)
    
    expect_equal(gpuA, gpuB)
    expect_is(gpuB, class(gpuA))
    expect_equal(gpuA[], gpuB[], tolerance=.Machine$double.eps ^ 0.5, 
                 info="fgpuVector deepcopy elements not equivalent")  
    
    gpuB[1] <- 42
    expect_false(isTRUE(all.equal(gpuA[], gpuB[], tolerance = .Machine$double.eps ^ 0.5)),
                 info = "dgpuVector deepcopy not distinct from source")
})

test_that("CPU Check Integer gpuMatrix deepcopy", {
    
    has_cpu_skip()
    
    gpuA <- gpuMatrix(Aint)
    
    # deepcopy
    gpuB <- deepcopy(gpuA)
    
    expect_equal(gpuA, gpuB)
    expect_is(gpuB, "igpuMatrix")
    expect_is(gpuB, class(gpuA))
    expect_equal(gpuA[], gpuB[],
                 info="integer matrix elements not equivalent")  
    
    gpuB[1,1] <- 42L
    expect_false(isTRUE(all.equal(gpuA[], gpuB[])),
                 info = "integer deepcopy not distinct from source")
})

test_that("CPU Check Single Precision gpuMatrix deepcopy", {
    
    has_cpu_skip()
    
    gpuA <- gpuMatrix(A, type="float")
    
    # deepcopy
    gpuB <- deepcopy(gpuA)
    
    expect_equal(gpuA, gpuB)
    expect_is(gpuB, class(gpuA))
    expect_equal(gpuA[], gpuB[], tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    gpuB[1,1] <- 42
    expect_false(isTRUE(all.equal(gpuA[], gpuB[], tolerance = 1e-07)),
                 info = "float deepcopy not distinct from source")
})

test_that("CPU Check Double Precision gpuMatrix deepcopy", {
    
    has_cpu_skip()
    
    gpuA <- gpuMatrix(A, type="double")
    
    # deepcopy
    gpuB <- deepcopy(gpuA)
    
    expect_equal(gpuA, gpuB)
    expect_is(gpuB, class(gpuA))
    expect_equal(gpuA[], gpuB[], tolerance=.Machine$double.eps ^ 0.5, 
                 info="float matrix elements not equivalent")  
    
    gpuB[1,1] <- 42
    expect_false(isTRUE(all.equal(gpuA[], gpuB[], tolerance = .Machine$double.eps ^ 0.5)),
                 info = "double deepcopy not distinct from source")
})

test_that("CPU Check Integer vclVector deepcopy", {
    
    has_cpu_skip()
    
    vclA <- vclVector(AintVec)
    
    # deepcopy
    vclB <- deepcopy(vclA)
    
    expect_equal(vclA, vclB)
    expect_is(vclB, "ivclVector")
    expect_is(vclB, class(vclA))
    expect_equal(vclA[], vclB[],
                 info="ivclVector deepcopy elements not equivalent")  
    
    vclB[1] <- 42L    
    expect_false(isTRUE(all.equal(vclA[], vclB[])),
                 info = "ivclVector deepcopy not distinct from source")
})

test_that("CPU Check Single Precision vclVector deepcopy", {
    
    has_cpu_skip()
    
    vclA <- vclVector(A, type="float")
    
    # deepcopy
    vclB <- deepcopy(vclA)
    
    expect_equal(vclA, vclB)
    expect_is(vclB, class(vclA))
    expect_equal(vclA[], vclB[], tolerance=1e-07, 
                 info="float deepcopy vclVector elements not equivalent")  
    
    vclB[1] <- 42
    expect_false(isTRUE(all.equal(vclA[], vclB[], tolerance = 1e-07)),
                 info = "fvclVector deepcopy not distinct from source")
})

test_that("CPU Check Double Precision vclVector deepcopy", {
    
    has_cpu_skip()
    
    vclA <- vclVector(A, type="double")
    
    # deepcopy
    vclB <- deepcopy(vclA)
    
    expect_equal(vclA, vclB)
    expect_is(vclB, class(vclA))
    expect_equal(vclA[], vclB[], tolerance=.Machine$double.eps ^ 0.5, 
                 info="fvclVector deepcopy elements not equivalent")  
    
    vclB[1] <- 42
    expect_false(isTRUE(all.equal(vclA[], vclB[], tolerance = .Machine$double.eps ^ 0.5)),
                 info = "dvclVector deepcopy not distinct from source")
})

test_that("CPU Check Integer vclMatrix deepcopy", {
    
    has_cpu_skip()
    
    vclA <- vclMatrix(Aint)
    
    # deepcopy
    vclB <- deepcopy(vclA)
    
    expect_equal(vclA, vclB)
    expect_is(vclB, "ivclMatrix")
    expect_is(vclB, class(vclA))
    expect_equal(vclA[], vclB[],
                 info="integer matrix elements not equivalent")  
    
    vclB[1,1] <- 42L    
    expect_false(isTRUE(all.equal(vclA[], vclB[])),
                 info = "integer deepcopy not distinct from source")
})

test_that("CPU Check Single Precision vclMatrix deepcopy", {
    
    has_cpu_skip()
    
    vclA <- vclMatrix(A, type="float")
    
    # deepcopy
    vclB <- deepcopy(vclA)
    
    expect_equal(vclA, vclB)
    expect_is(vclB, class(vclA))
    expect_equal(vclA[], vclB[], tolerance=1e-07, 
                 info="float matrix elements not equivalent")  
    
    vclB[1,1] <- 42
    expect_false(isTRUE(all.equal(vclA[], vclB[], tolerance = 1e-07)),
                 info = "float deepcopy not distinct from source")
})

test_that("CPU Check Double Precision vclMatrix deepcopy", {
    
    has_cpu_skip()
    
    vclA <- vclMatrix(A, type="double")
    
    # deepcopy
    vclB <- deepcopy(vclA)
    
    expect_equal(vclA, vclB)
    expect_is(vclB, class(vclA))
    expect_equal(vclA[], vclB[], tolerance=.Machine$double.eps ^ 0.5, 
                 info="float matrix elements not equivalent")  
    
    vclB[1,1] <- 42
    expect_false(isTRUE(all.equal(vclA[], vclB[], tolerance = .Machine$double.eps ^ 0.5)),
                 info = "double deepcopy not distinct from source")
})

setContext(current_context)
