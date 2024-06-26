
#include "gpuR/windows_check.hpp"

// eigen headers for handling the R input data
#include <RcppEigen.h>

#include "gpuR/dynEigenMat.hpp"
#include "gpuR/dynEigenVec.hpp"
#include "gpuR/dynVCLMat.hpp"
#include "gpuR/dynVCLVec.hpp"

// Use OpenCL with ViennaCL
#define VIENNACL_WITH_OPENCL 1

// Use ViennaCL algorithms on Eigen objects
#define VIENNACL_WITH_EIGEN 1

// ViennaCL headers
#include "viennacl/ocl/device.hpp"
#include "viennacl/ocl/platform.hpp"
#include "viennacl/matrix.hpp"
#include "viennacl/linalg/prod.hpp"
#include "viennacl/linalg/sum.hpp"

using namespace Rcpp;

/*** gpuMatrix Templates ***/

template <typename T>
void 
cpp_gpuMatrix_colmean(
    SEXP ptrA_, 
    SEXP ptrC_)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenVec<T> > ptrC(ptrC_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, 1> > colMeans = ptrC->data();
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    
    const int K = vcl_A.size1();
    const int V = colMeans.size();
    
    viennacl::vector_base<T> vcl_colMeans(V, ctx);
    
    vcl_colMeans = viennacl::linalg::column_sum(vcl_A);
    vcl_colMeans *= (T)(1)/(T)(K);
    
    // viennacl::copy(vcl_colMeans, colMeans);
    viennacl::fast_copy(vcl_colMeans.begin(), vcl_colMeans.end(), &(colMeans[0]));
}

template <typename T>
void 
cpp_gpuMatrix_colsum(
    SEXP ptrA_, SEXP ptrC_)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenVec<T> > ptrC(ptrC_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, 1> > colSums = ptrC->data();
    
    const int V = colSums.size();
    
    viennacl::vector_base<T> vcl_colSums(V, ctx);
    
    vcl_colSums = viennacl::linalg::column_sum(vcl_A);
    
    // viennacl::copy(vcl_colSums, colSums);
    viennacl::fast_copy(vcl_colSums.begin(), vcl_colSums.end(), &(colSums[0]));
}

template <typename T>
void 
cpp_gpuMatrix_rowmean(
    SEXP ptrA_, SEXP ptrC_)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenVec<T> > ptrC(ptrC_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, 1> > rowMeans = ptrC->data();
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    
    const int M = vcl_A.size2();
    const int V = rowMeans.size();
    
    viennacl::vector_base<T> vcl_rowMeans(V, ctx);
    
    vcl_rowMeans = viennacl::linalg::row_sum(vcl_A);
    vcl_rowMeans *= (T)(1)/(T)(M);
    
    // viennacl::copy(vcl_rowMeans, rowMeans);
    viennacl::fast_copy(vcl_rowMeans.begin(), vcl_rowMeans.end(), &(rowMeans[0]));
}

template <typename T>
void
cpp_gpuMatrix_rowsum(
    SEXP ptrA_, SEXP ptrC_)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenVec<T> > ptrC(ptrC_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    Eigen::Map<Eigen::Matrix<T, Eigen::Dynamic, 1> > rowSums = ptrC->data();
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    
    const int V = rowSums.size();
    
    viennacl::vector_base<T> vcl_rowSums(V, ctx);
    
    vcl_rowSums = viennacl::linalg::row_sum(vcl_A);
    
    // viennacl::copy(vcl_rowSums, rowSums);
    viennacl::fast_copy(vcl_rowSums.begin(), vcl_rowSums.end(), &(rowSums[0]));
}

template <typename T>
SEXP
cpp_gpuMatrix_sum(
    SEXP ptrA_)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    
    T res = viennacl::linalg::sum(viennacl::linalg::row_sum(vcl_A));
    
    return Rcpp::wrap(res);
}

/*** vclMatrix Templates ***/

template <typename T>
void 
cpp_vclMatrix_colmean(
    SEXP ptrA_, 
    SEXP ptrC_)
{
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLVec<T> > pC(ptrC_);
    
    viennacl::vector_range<viennacl::vector_base<T> > vcl_colMeans  = pC->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    
    const int K = vcl_A.size1();
        
    vcl_colMeans = viennacl::linalg::column_sum(vcl_A);
    vcl_colMeans *= (T)(1)/(T)(K);
}

template <typename T>
void 
cpp_vclMatrix_colsum(
    SEXP ptrA_, 
    SEXP ptrC_)
{
    
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLVec<T> > pC(ptrC_);
    
    viennacl::vector_range<viennacl::vector_base<T> > vcl_colSums  = pC->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    
    vcl_colSums = viennacl::linalg::column_sum(vcl_A);
}

template <typename T>
void 
cpp_vclMatrix_rowmean(
    SEXP ptrA_, 
    SEXP ptrC_)
{
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLVec<T> > pC(ptrC_);
    viennacl::vector_range<viennacl::vector_base<T> > vcl_rowMeans  = pC->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();

    const int M = vcl_A.size2();
    
    vcl_rowMeans = viennacl::linalg::row_sum(vcl_A);
    vcl_rowMeans *= (T)(1)/(T)(M);
}

template <typename T>
void
cpp_vclMatrix_rowsum(
    SEXP ptrA_, 
    SEXP ptrC_)
{
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLVec<T> > pC(ptrC_);
    viennacl::vector_range<viennacl::vector_base<T> > vcl_rowSums  = pC->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    
    vcl_rowSums = viennacl::linalg::row_sum(vcl_A);
}

template <typename T>
SEXP
cpp_vclMatrix_sum(
    SEXP ptrA_)
{
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    
    T res = viennacl::linalg::sum(viennacl::linalg::row_sum(vcl_A));
    return wrap(res);
}


template <typename T>
void 
cpp_gpuMatrix_pmcc(
    SEXP ptrA_, 
    SEXP ptrB_)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenMat<T> > ptrB(ptrB_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    
    const int K = vcl_A.size1();
    const int M = vcl_A.size2();
    // T one = 1;
    
    // viennacl::vector_base<T> ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(K, 1, ctx));
    
    viennacl::vector_base<T> ones = viennacl::vector_base<T>(K, ctx);
    viennacl::linalg::vector_assign(ones, (T)(1));
    
    viennacl::vector_base<T> vcl_meanVec(M, ctx);
    viennacl::matrix<T> vcl_meanMat(K,M, ctx);
    
    // vector of column means
    vcl_meanVec = viennacl::linalg::column_sum(vcl_A);
    vcl_meanVec *= (T)(1)/(T)(K);
    
    // matrix of means
    vcl_meanMat = viennacl::linalg::outer_prod(ones, vcl_meanVec);
    
    viennacl::matrix<T> tmp = vcl_A - vcl_meanMat;
    
    // calculate pearson covariance
    viennacl::matrix<T> vcl_B = viennacl::linalg::prod(trans(tmp), tmp);
    vcl_B *= (T)(1)/(T)(K-1);
    
    ptrB->to_host(vcl_B);
}

template <typename T>
void 
cpp_gpuMatrix_pmcc2(
    SEXP ptrA_, 
    SEXP ptrB_,
    SEXP ptrC_)
{
    
    Rcpp::XPtr<dynEigenMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynEigenMat<T> > ptrB(ptrB_);
    Rcpp::XPtr<dynEigenMat<T> > ptrC(ptrC_);
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    viennacl::matrix<T> vcl_B = ptrB->device_data();
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    const int M = vcl_A.size2();
    const int M2 = vcl_B.size2();
    const int K = vcl_A.size1();
    
    // viennacl::vector_base<T> ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(K, 1, ctx));
    viennacl::vector_base<T> ones = viennacl::vector_base<T>(K, ctx);
    viennacl::linalg::vector_assign(ones, (T)(1));
    
    viennacl::vector_base<T> vcl_meanVec(M, ctx);
    viennacl::vector_base<T> vclB_meanVec(M2, ctx);
    viennacl::matrix<T> vclA_meanMat(K,M, ctx);
    viennacl::matrix<T> vclB_meanMat(K,M2, ctx);
    
    // matrix A
    // vector of column means
    vcl_meanVec = viennacl::linalg::column_sum(vcl_A);
    vcl_meanVec *= (T)(1)/(T)(K);
    
    // matrix of means
    vclA_meanMat = viennacl::linalg::outer_prod(ones, vcl_meanVec);
    
    // matrix B
    // vector of column means
    vclB_meanVec = viennacl::linalg::column_sum(vcl_B);
    vclB_meanVec *= (T)(1)/(T)(K);
    
    // matrix of means
    vclB_meanMat = viennacl::linalg::outer_prod(ones, vclB_meanVec);
    
    viennacl::matrix<T> tmp = vcl_A - vclA_meanMat;
    viennacl::matrix<T> tmp2 = vcl_B - vclB_meanMat;
    
    // calculate pearson covariance
    viennacl::matrix<T> vcl_C = viennacl::linalg::prod(trans(tmp), tmp2);
    vcl_C *= (T)(1)/(T)(K-1);
    
    ptrC->to_host(vcl_C);
}

template <typename T>
void 
cpp_vclMatrix_pmcc(
    SEXP ptrA_, 
    SEXP ptrB_,
    int ctx_id)
{
    
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLMat<T> > ptrB(ptrB_);
    
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_B = ptrB->data();

    viennacl::context ctx(viennacl::ocl::get_context(ctx_id));
    
    const int M = vcl_A.size2();
    const int K = vcl_A.size1();
    
    // viennacl::vector_base<T> ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(K, 1, ctx));
    viennacl::vector_base<T> ones = viennacl::vector_base<T>(K, ctx);
    viennacl::linalg::vector_assign(ones, (T)(1));
    
    viennacl::vector_base<T> vcl_meanVec(M, ctx);
    viennacl::matrix<T> vcl_meanMat(K,M, ctx);
    
    // vector of column means
    vcl_meanVec = viennacl::linalg::column_sum(vcl_A);
    vcl_meanVec *= (T)(1)/(T)(K);
    
    // matrix of means
    vcl_meanMat = viennacl::linalg::outer_prod(ones, vcl_meanVec);
    
    viennacl::matrix<T> tmp = vcl_A - vcl_meanMat;
    
    // calculate pearson covariance
    vcl_B = viennacl::linalg::prod(trans(tmp), tmp);
    vcl_B *= (T)(1)/(T)(K-1);
}

template <typename T>
void 
cpp_vclMatrix_pmcc2(
    SEXP ptrA_, 
    SEXP ptrB_,
    SEXP ptrC_,
    int ctx_id)
{
    
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLMat<T> > ptrB(ptrB_);
    Rcpp::XPtr<dynVCLMat<T> > ptrC(ptrC_);
    
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_B = ptrB->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_C = ptrC->data();
    
    viennacl::context ctx(viennacl::ocl::get_context(ctx_id));
    
    const int M = vcl_A.size2();
    const int M2 = vcl_B.size2();
    const int K = vcl_A.size1();
    
    // viennacl::vector_base<T> ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(K, 1, ctx));
    viennacl::vector_base<T> ones = viennacl::vector_base<T>(K, ctx);
    viennacl::linalg::vector_assign(ones, (T)(1));
    
    viennacl::vector_base<T> vcl_meanVec(M, ctx);
    viennacl::vector_base<T> vclB_meanVec(M2, ctx);
    viennacl::matrix<T> vclA_meanMat(K,M, ctx);
    viennacl::matrix<T> vclB_meanMat(K,M2, ctx);
    
    // matrix A
    // vector of column means
    vcl_meanVec = viennacl::linalg::column_sum(vcl_A);
    vcl_meanVec *= (T)(1)/(T)(K);
    
    // matrix of means
    vclA_meanMat = viennacl::linalg::outer_prod(ones, vcl_meanVec);
    
    // matrix B
    // vector of column means
    vclB_meanVec = viennacl::linalg::column_sum(vcl_B);
    vclB_meanVec *= (T)(1)/(T)(K);
    
    // matrix of means
    vclB_meanMat = viennacl::linalg::outer_prod(ones, vclB_meanVec);
    
    viennacl::matrix<T> tmp = vcl_A - vclA_meanMat;
    viennacl::matrix<T> tmp2 = vcl_B - vclB_meanMat;
    
    // calculate pearson covariance
    vcl_C = viennacl::linalg::prod(trans(tmp), tmp2);
    vcl_C *= (T)(1)/(T)(K-1);
}

template <typename T>
void 
cpp_gpuMatrix_eucl(
    SEXP ptrA_, 
    SEXP ptrD_,
    bool squareDist)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenMat<T> > ptrD(ptrD_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    viennacl::matrix<T> vcl_D = viennacl::zero_matrix<T>(vcl_A.size1(), vcl_A.size1(), ctx);
    
    // temp objects
    // viennacl::vector_base<T> row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(K, 1, ctx));
    // viennacl::vector_base<T> vcl_sqrt = static_cast<viennacl::vector_base<T> >(viennacl::zero_vector<T>(K, ctx));
    // viennacl::vector_base<T> vcl_sqrt = viennacl::vector_base<T>(K, ctx);
    
    viennacl::vector_base<T> vcl_sqrt;
    
    // this will definitely need to be updated with the next ViennaCL release
    // currently doesn't support the single scalar operation with
    // element_pow below
    {
        viennacl::matrix<T> twos = viennacl::scalar_matrix<T>(vcl_A.size1(), vcl_A.size2(), 2, ctx);
        
        viennacl::matrix<T> square_A = viennacl::linalg::element_pow(vcl_A, twos);
        
        vcl_sqrt = viennacl::linalg::row_sum(square_A);
    }
    
    {
        // viennacl::vector_base<T> row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(vcl_A.size1(), 1, ctx));
        viennacl::vector_base<T> row_ones = viennacl::vector_base<T>(vcl_A.size1(), ctx);
        viennacl::linalg::vector_assign(row_ones, (T)(1));
        
        vcl_D = viennacl::linalg::outer_prod(vcl_sqrt, row_ones);
    }
    
    vcl_D += trans(vcl_D);
    
    vcl_D -= 2 * (viennacl::linalg::prod(vcl_A, trans(vcl_A)));
    
    if(!squareDist){
        vcl_D = viennacl::linalg::element_sqrt(vcl_D);   
    }
    
    for(unsigned int i=0; i < vcl_D.size1(); i++){
        vcl_D(i,i) = 0;
    }
    
    ptrD->to_host(vcl_D);
}

template <typename T>
void 
cpp_gpuMatrix_peucl(
    SEXP ptrA_, 
    SEXP ptrB_,
    SEXP ptrD_,
    bool squareDist)
{
    XPtr<dynEigenMat<T> > ptrA(ptrA_);
    XPtr<dynEigenMat<T> > ptrB(ptrB_);
    XPtr<dynEigenMat<T> > ptrD(ptrD_);
    
    viennacl::context ctx(viennacl::ocl::get_context(ptrA->getContext()));
    
    // copy to GPU
    viennacl::matrix<T> vcl_A = ptrA->device_data();
    viennacl::matrix<T> vcl_B = ptrB->device_data();
    viennacl::matrix<T> vcl_D = viennacl::zero_matrix<T>(vcl_A.size1(), vcl_B.size1(), ctx);
    
    const int M = vcl_A.size2();
    const int K = vcl_A.size1();
    const int R = vcl_B.size2();
    const int Q = vcl_B.size1();
    
    // viennacl::vector_base<T> A_row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(K, 1, ctx));
    // viennacl::vector_base<T> B_row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(Q, 1, ctx));
    viennacl::vector_base<T> A_row_ones = viennacl::vector_base<T>(K, ctx);
    viennacl::vector_base<T> B_row_ones = viennacl::vector_base<T>(Q, ctx);
    viennacl::linalg::vector_assign(A_row_ones, (T)(1));
    viennacl::linalg::vector_assign(B_row_ones, (T)(1));
    
    viennacl::matrix<T> square_A = viennacl::zero_matrix<T>(vcl_A.size1(), vcl_A.size2(), ctx);
    viennacl::matrix<T> square_B = viennacl::zero_matrix<T>(vcl_B.size1(), vcl_B.size2(), ctx);
    
    // this will definitely need to be updated with the next ViennaCL release
    // currently doesn't support the single scalar operation with
    // element_pow below
    {
        viennacl::matrix<T> twos = viennacl::scalar_matrix<T>(std::max(K, Q), std::max(M, R), 2, ctx);
    
        square_A = viennacl::linalg::element_pow(vcl_A, twos);
        square_B = viennacl::linalg::element_pow(vcl_B, twos);
    }
    
    {
        // viennacl::vector_base<T> vcl_A_rowsum = static_cast<viennacl::vector_base<T> >(viennacl::zero_vector<T>(K, ctx));
        // viennacl::vector_base<T> vcl_B_rowsum = static_cast<viennacl::vector_base<T> >(viennacl::zero_vector<T>(Q, ctx));
        viennacl::vector_base<T> vcl_A_rowsum = viennacl::vector_base<T>(K, ctx);
        viennacl::vector_base<T> vcl_B_rowsum = viennacl::vector_base<T>(Q, ctx);
        viennacl::linalg::vector_assign(vcl_A_rowsum, (T)(1));
        viennacl::linalg::vector_assign(vcl_B_rowsum, (T)(1));
        
        vcl_A_rowsum = viennacl::linalg::row_sum(square_A);
        vcl_B_rowsum = viennacl::linalg::row_sum(square_B);
        
        viennacl::matrix<T> vclXX = viennacl::linalg::outer_prod(vcl_A_rowsum, B_row_ones);
        viennacl::matrix<T> vclYY = viennacl::linalg::outer_prod(A_row_ones, vcl_B_rowsum);
        
        vcl_D = vclXX + vclYY;
        vcl_D -= 2 * (viennacl::linalg::prod(vcl_A, trans(vcl_B)));
    }
    
    if(!squareDist){
        vcl_D = viennacl::linalg::element_sqrt(vcl_D);    
    }
    
    ptrD->to_host(vcl_D);
        
}

template <typename T>
void 
cpp_vclMatrix_eucl(
    SEXP ptrA_, 
    SEXP ptrD_,
    bool squareDist,
    int ctx_id)
{
    viennacl::context ctx;
    
    // explicitly pull context for thread safe forking
    ctx = viennacl::context(viennacl::ocl::get_context(static_cast<long>(ctx_id)));

    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLMat<T> > ptrD(ptrD_);
    
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_D = ptrD->data();
    
    viennacl::vector_base<T> vcl_sqrt;
    
    // this will definitely need to be updated with the next ViennaCL release
    // currently doesn't support the single scalar operation with
    // element_pow below
    {
        viennacl::matrix<T> twos = viennacl::scalar_matrix<T>(vcl_A.size1(), vcl_A.size2(), 2, ctx);
        
        viennacl::matrix<T> square_A = viennacl::linalg::element_pow(vcl_A, twos);
        vcl_sqrt = viennacl::linalg::row_sum(square_A);
    }
    
    
    {
        // viennacl::vector_base<T> row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(vcl_A.size1(), 1, ctx));
        viennacl::vector_base<T> row_ones = viennacl::vector_base<T>(vcl_A.size1(), ctx);
        viennacl::linalg::vector_assign(row_ones, (T)(1));
        
        vcl_D = viennacl::linalg::outer_prod(vcl_sqrt, row_ones);
    }
    
    vcl_D += trans(vcl_D);
    
//    viennacl::matrix<T> temp = 2 * (viennacl::linalg::prod(vcl_A, trans(vcl_A)));
    
    vcl_D -= 2 * (viennacl::linalg::prod(vcl_A, trans(vcl_A)));
    
    if(!squareDist){
        vcl_D = viennacl::linalg::element_sqrt(vcl_D);    
    }
    
    for(unsigned int i=0; i < vcl_D.size1(); i++){
        vcl_D(i,i) = 0;
    }
        
}

template <typename T>
void 
cpp_vclMatrix_peucl(
    SEXP ptrA_, 
    SEXP ptrB_,
    SEXP ptrD_,
    bool squareDist,
    int ctx_id)
{ 
    
    Rcpp::XPtr<dynVCLMat<T> > ptrA(ptrA_);
    Rcpp::XPtr<dynVCLMat<T> > ptrB(ptrB_);
    Rcpp::XPtr<dynVCLMat<T> > ptrD(ptrD_);
    
    viennacl::matrix_range<viennacl::matrix<T> > vcl_A = ptrA->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_B = ptrB->data();
    viennacl::matrix_range<viennacl::matrix<T> > vcl_D = ptrD->data();
    
    viennacl::matrix<T> square_A;
    viennacl::matrix<T> square_B;
    viennacl::context ctx;
    
    // explicitly pull context for thread safe forking
    ctx = viennacl::context(viennacl::ocl::get_context(static_cast<long>(ctx_id)));
 
//    std::cout << "pulled data" << std::endl;
    
    // this will definitely need to be updated with the next ViennaCL release
    // currently doesn't support the single scalar operation with
    // element_pow below
    {
        viennacl::matrix<T> twos = viennacl::scalar_matrix<T>(std::max(vcl_A.size1(), vcl_B.size1()), std::max(vcl_A.size2(), vcl_B.size2()), 2, ctx);
    
        square_A = viennacl::linalg::element_pow(vcl_A, twos);
        square_B = viennacl::linalg::element_pow(vcl_B, twos);
    }
    
//    std::cout << "power calculation complete" << std::endl;
    
    {
        // viennacl::vector_base<T> x_row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(vcl_A.size1(), 1, ctx));
        // viennacl::vector_base<T> y_row_ones = static_cast<viennacl::vector_base<T> >(viennacl::scalar_vector<T>(vcl_B.size1(), 1, ctx));
        // 
        // viennacl::vector_base<T> vcl_A_rowsum = static_cast<viennacl::vector_base<T> >(viennacl::zero_vector<T>(vcl_A.size1(), ctx));
        // viennacl::vector_base<T> vcl_B_rowsum = static_cast<viennacl::vector_base<T> >(viennacl::zero_vector<T>(vcl_B.size1(), ctx));
        
        viennacl::vector_base<T> x_row_ones = viennacl::vector_base<T>(vcl_A.size1(), ctx);
        viennacl::vector_base<T> y_row_ones = viennacl::vector_base<T>(vcl_B.size1(), ctx);
        viennacl::vector_base<T> vcl_A_rowsum = viennacl::vector_base<T>(vcl_A.size1(), ctx);
        viennacl::vector_base<T> vcl_B_rowsum = viennacl::vector_base<T>(vcl_B.size1(), ctx);
        
        viennacl::linalg::vector_assign(x_row_ones, (T)(1));
        viennacl::linalg::vector_assign(y_row_ones, (T)(1));
        viennacl::linalg::vector_assign(vcl_A_rowsum, (T)(0));
        viennacl::linalg::vector_assign(vcl_A_rowsum, (T)(0));
        
        
        vcl_A_rowsum = viennacl::linalg::row_sum(square_A);
        vcl_B_rowsum = viennacl::linalg::row_sum(square_B);
        
//        std::cout << "row sums complete" << std::endl;
        
        viennacl::matrix<T> vclXX = viennacl::linalg::outer_prod(vcl_A_rowsum, y_row_ones);
        //std::cout << vclXX << std::endl;
        viennacl::matrix<T> vclYY = viennacl::linalg::outer_prod(x_row_ones, vcl_B_rowsum);
//        std::cout << "outer products complete" << std::endl;
        //    std::cout << vclYY << std::endl;
        vcl_D = vclXX + vclYY;
    }
    
    
    vcl_D -= 2 * (viennacl::linalg::prod(vcl_A, trans(vcl_B)));
    
    if(!squareDist){
        vcl_D = viennacl::linalg::element_sqrt(vcl_D);    
    }
    
//    for(unsigned int i=0; i < vcl_D.size1(); i++){
//        vcl_D(i,i) = 0;
//    }
//    viennacl::diag(vcl_D) = viennacl::zero_vector<T>(vcl_A.size1());
        
}

// [[Rcpp::export]]
void
cpp_gpuMatrix_pmcc(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_pmcc<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_gpuMatrix_pmcc<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_gpuMatrix_pmcc<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_gpuMatrix_pmcc2(
    SEXP ptrA, SEXP ptrB, SEXP ptrC,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_pmcc2<int>(ptrA, ptrB, ptrC);
            return;
        case 6:
            cpp_gpuMatrix_pmcc2<float>(ptrA, ptrB, ptrC);
            return;
        case 8:
            cpp_gpuMatrix_pmcc2<double>(ptrA, ptrB, ptrC);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_vclMatrix_pmcc(
    SEXP ptrA, SEXP ptrB,
    const int type_flag,
    int ctx_id)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_pmcc<int>(ptrA, ptrB, ctx_id);
            return;
        case 6:
            cpp_vclMatrix_pmcc<float>(ptrA, ptrB, ctx_id);
            return;
        case 8:
            cpp_vclMatrix_pmcc<double>(ptrA, ptrB, ctx_id);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_vclMatrix_pmcc2(
    SEXP ptrA, SEXP ptrB, SEXP ptrC,
    const int type_flag,
    int ctx_id)
{
    
    switch(type_flag) {
    case 4:
        cpp_vclMatrix_pmcc2<int>(ptrA, ptrB, ptrC, ctx_id);
        return;
    case 6:
        cpp_vclMatrix_pmcc2<float>(ptrA, ptrB, ptrC, ctx_id);
        return;
    case 8:
        cpp_vclMatrix_pmcc2<double>(ptrA, ptrB, ptrC, ctx_id);
        return;
    default:
        throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}


// [[Rcpp::export]]
void
cpp_vclMatrix_eucl(
    SEXP ptrA, SEXP ptrD,
    bool squareDist,
    const int type_flag,
    int ctx_id)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_eucl<int>(ptrA, ptrD, squareDist, ctx_id);
            return;
        case 6:
            cpp_vclMatrix_eucl<float>(ptrA, ptrD, squareDist, ctx_id);
            return;
        case 8:
            cpp_vclMatrix_eucl<double>(ptrA, ptrD, squareDist, ctx_id);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_vclMatrix_peucl(
    SEXP ptrA, SEXP ptrB, SEXP ptrD,
    bool squareDist,
    const int type_flag,
    int ctx_id)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_peucl<int>(ptrA, ptrB, ptrD, squareDist, ctx_id);
            return;
        case 6:
            cpp_vclMatrix_peucl<float>(ptrA, ptrB, ptrD, squareDist, ctx_id);
            return;
        case 8:
            cpp_vclMatrix_peucl<double>(ptrA, ptrB, ptrD, squareDist, ctx_id);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_gpuMatrix_eucl(
    SEXP ptrA, SEXP ptrD,
    bool squareDist,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_eucl<int>(ptrA, ptrD, squareDist);
            return;
        case 6:
            cpp_gpuMatrix_eucl<float>(ptrA, ptrD, squareDist);
            return;
        case 8:
            cpp_gpuMatrix_eucl<double>(ptrA, ptrD, squareDist);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_gpuMatrix_peucl(
    SEXP ptrA, SEXP ptrB, SEXP ptrD,
    bool squareDist,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_peucl<int>(ptrA, ptrB, ptrD, squareDist);
            return;
        case 6:
            cpp_gpuMatrix_peucl<float>(ptrA, ptrB, ptrD, squareDist);
            return;
        case 8:
            cpp_gpuMatrix_peucl<double>(ptrA, ptrB, ptrD, squareDist);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

/*** gpuMatrix Functions ***/

// [[Rcpp::export]]
void
cpp_gpuMatrix_colmean(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_colmean<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_gpuMatrix_colmean<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_gpuMatrix_colmean<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_gpuMatrix_colsum(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_colsum<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_gpuMatrix_colsum<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_gpuMatrix_colsum<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_gpuMatrix_rowmean(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_rowmean<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_gpuMatrix_rowmean<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_gpuMatrix_rowmean<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}


// [[Rcpp::export]]
void
cpp_gpuMatrix_rowsum(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_gpuMatrix_rowsum<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_gpuMatrix_rowsum<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_gpuMatrix_rowsum<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_gpuMatrix_sum(
    SEXP ptrA,
    const int type_flag)
{
    
    switch(type_flag) {
    case 4:
        return cpp_gpuMatrix_sum<int>(ptrA);
    case 6:
        return cpp_gpuMatrix_sum<float>(ptrA);
    case 8:
        return cpp_gpuMatrix_sum<double>(ptrA);
    default:
        throw Rcpp::exception("unknown type detected for gpuMatrix object!");
    }
}

/*** vclMatrix Functions ***/

// [[Rcpp::export]]
void
cpp_vclMatrix_colmean(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_colmean<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_vclMatrix_colmean<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_vclMatrix_colmean<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_vclMatrix_colsum(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_colsum<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_vclMatrix_colsum<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_vclMatrix_colsum<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}

// [[Rcpp::export]]
void
cpp_vclMatrix_rowmean(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_rowmean<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_vclMatrix_rowmean<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_vclMatrix_rowmean<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}


// [[Rcpp::export]]
void
cpp_vclMatrix_rowsum(
    SEXP ptrA, SEXP ptrB,
    const int type_flag)
{
    
    switch(type_flag) {
        case 4:
            cpp_vclMatrix_rowsum<int>(ptrA, ptrB);
            return;
        case 6:
            cpp_vclMatrix_rowsum<float>(ptrA, ptrB);
            return;
        case 8:
            cpp_vclMatrix_rowsum<double>(ptrA, ptrB);
            return;
        default:
            throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}

// [[Rcpp::export]]
SEXP
cpp_vclMatrix_sum(
    SEXP ptrA,
    const int type_flag)
{
    
    switch(type_flag) {
    case 4:
        return cpp_vclMatrix_sum<int>(ptrA);
    case 6:
        return cpp_vclMatrix_sum<float>(ptrA);
    case 8:
        return cpp_vclMatrix_sum<double>(ptrA);
    default:
        throw Rcpp::exception("unknown type detected for vclMatrix object!");
    }
}
