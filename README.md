# gpuR

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1027597.svg)](https://doi.org/10.5281/zenodo.1027597)

### Gitter rooms available for discussion
[![chat](https://img.shields.io/badge/gitter-chat-brightgreen.svg)](https://app.gitter.im/#/room/#cdeterman_gpuR:gitter.im)
[![general](https://img.shields.io/badge/gitter-general-brightgreen.svg)]( https://app.gitter.im/#/room/#cdeterman_gpuR_general:gitter.im)
[![development](https://img.shields.io/badge/gitter-development-brightgreen.svg)](https://app.gitter.im/#/room/#cdeterman_gpuR_development:gitter.im)
[![testing](https://img.shields.io/badge/gitter-testing-brightgreen.svg)](https://app.gitter.im/#/room/#cdeterman_gpuR_Tested_GPUs:gitter.im)

### Build Status
|                 | Build           | Dev             |
|-----------------|-----------------|-----------------|
| Linux x86_64    | [![Build Status](https://travis-ci.com/cdeterman/gpuR.png?branch=master)](https://app.travis-ci.com/github/cdeterman/gpuR)      | [![Build Status](https://travis-ci.com/cdeterman/gpuR.png?branch=develop)](https://www.travis-ci.com/github/cdeterman/gpuR) |
| OSX             | [![Build Status](https://travis-ci.com/cdeterman/gpuR.png?branch=master-macosx)]( https://app.travis-ci.com/github/cdeterman/gpuR)   | [![Build Status](https://travis-ci.com/cdeterman/gpuR.png?branch=macosx)](https://app.travis-ci.com/github/cdeterman/gpuR) |
| Windows x86     | [![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/github/cdeterman/gpuR?branch=master&svg=true)](https://ci.appveyor.com/project/cdeterman/gpuR)     | [![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/github/cdeterman/gpuR?branch=develop&svg=true)](https://ci.appveyor.com/project/cdeterman/gpuR) |

Test coverage: [![Coverage Status](https://coveralls.io/repos/cdeterman/gpuR/badge.svg)](https://coveralls.io/github/cdeterman/gpuR)

Community Use: [![Downloads](https://cranlogs.r-pkg.org/badges/gpuR?color=brightgreen)](https://www.r-pkg.org/pkg/gpuR)

Welcome to my R package for simple GPU computing.  Although there are a few
existing packages to leverage the power of GPU's they are either specific
to one brand (e.g. NVIDIA) or are not very user friendly.  The goal of this
package is to provide the user a very simple R API that can be used with
any GPU (via an OpenCL backend).  This is accomplished by interfacing with the 
ViennaCL library that I have packaged in the R package 
[RViennaCL](https://CRAN.R-project.org/package=RViennaCL).  To make the R API simple,
I created new classes similar to the structure of the 
[Matrix](https://CRAN.R-project.org/package=Matrix)
package.  By doing so, typical methods may be overloaded to make for a very
pleasing sytax.  For example, to perform vector addition the syntax is: 

```r
A <- seq.int(from=0, to=999)
B <- seq.int(from=1000, to=1)
gpuA <- gpuVector(A)
gpuB <- gpuVector(B)

C <- A + B
gpuC <- gpuA + gpuB

all(C == gpuC)
[1] TRUE
```

I also recommend you read the vignette I included with this package to
get a better understanding of its' capabilities.

```r
vignette("gpuR")
```

Please note, all the functions herein use an OpenCL backend.  If you prefer
to have a CUDA based backend, please see my other package 
[gpuRcuda](https://github.com/gpuRcore/gpuRcuda) which is simply an extension
on top of this package where all functions herein are still applicable
but also have the CUDA option available.  

# INSTALL
Please see my [github wiki](https://github.com/cdeterman/gpuR/wiki) for
installation instructions relevant to your operating system.

# Things to Do
1. Obviously more vector functions and matrix implementations
2. My resources limit how much I can test (e.g. OS, GPU vendors).  Would
appreciate any feedback on how the installation and use fairs with other
platforms and GPUs.
2. Would love any suggestions :) (submit in the issues)
