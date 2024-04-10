Thank you for your patience, getting there.  Because of dependence on opencl drivers there might be more complications at the next stage.

- Khronos Group has been added to Authors <cph>, the inst/COPYRIGHTS file states that some header files contain copyright information specific to that file
- Issues which caused removal from cran have been fixed (in particular assigning object to itself warnings)
- BH and RcppEigen packages must be in IMPORTS because of "custom kernels", one of the tests (test_custom.R) calls C code which uses BH and RcppEigen, checks complain that package not found unless BH and RcppEigen are in IMPORTS.
