#include "gpuR/windows_check.hpp"
// #include "gpuR/cl_helpers.hpp"

// Use OpenCL with ViennaCL
#define VIENNACL_WITH_OPENCL 1
//#define VIENNACL_DEBUG_ALL 1

// ViennaCL headers
#include "viennacl/ocl/device.hpp"
#include "viennacl/ocl/platform.hpp"
#include "viennacl/ocl/backend.hpp"

#include <Rcpp.h>

// using namespace cl;
using namespace Rcpp;

// [[Rcpp::export]]
String initContexts(){
    // declarations
    int id = 0;
    String themessage;
    
    // get platforms
    typedef std::vector< viennacl::ocl::platform > platforms_type;
    platforms_type platforms = viennacl::ocl::get_platforms();
    
    Rcpp::Function msg = Rcpp::Environment::base_env()["packageStartupMessage"];
    
    themessage = "Number of platforms: ";
    themessage += std::to_string(platforms.size());
    themessage += "\n";
    

    for(unsigned int plat_idx = 0; plat_idx < platforms.size(); plat_idx++) {
        

        themessage += "- platform: ";
        themessage += platforms[plat_idx].info();
        themessage += "\n";
        
        std::vector< viennacl::ocl::device > devices;
        devices = platforms[plat_idx].devices(CL_DEVICE_TYPE_ALL);
    
        for(unsigned int gpu_idx = 0; gpu_idx < devices.size(); gpu_idx++) {
            
            themessage += "  - context device index: ";
            themessage += std::to_string(gpu_idx);
            themessage += "\n";
            viennacl::ocl::set_context_platform_index(id, plat_idx);
            viennacl::ocl::setup_context(id, devices[gpu_idx]);
            themessage +=  "    - ";
            themessage += devices[gpu_idx].name();
            themessage +=  "\n";
            
            // increment context
            id++;
            themessage += "\n";
        }
    }
    
//    msg(Rcpp::wrap(themessage));
    
//    msg(Rcpp::wrap("checked all devices"));
    
    viennacl::ocl::switch_context(0);
//    msg(Rcpp::wrap("completed initialization"));
    return themessage;
}


////'@export
//// [[Rcpp::export]]
//void debugContexts(){
//    
//    typedef std::vector< viennacl::ocl::platform > platforms_type;
//    
//    // get platforms
//    platforms_type platforms = viennacl::ocl::get_platforms();  
//    
//    std::vector< viennacl::ocl::device > devices;
//    devices = platforms[0].devices();
//    
//    //devices = viennacl::ocl::current_context().devices();
//    
//    Rcout << "devices found on default platform" << std::endl;
//    Rcout << devices.size() << std::endl;
//    
//    for(unsigned int gpu_idx=0; gpu_idx < devices.size(); gpu_idx++){
//        viennacl::ocl::device gpu = devices[gpu_idx];
//        
//        Rcout << "device index" << std::endl;
//        Rcout << gpu_idx << std::endl;
//        
//        Rcout << "device name" << std::endl;
//        Rcout << gpu.name() << std::endl;
//    }
//}



//' @title Available OpenCL Contexts
//' @description Provide a data.frame of available OpenCL contexts and
//' associated information.
//' @return data.frame containing the following fields
//' @return \item{context}{Integer identifying context}
//' @return \item{platform}{Character string listing OpenCL platform}
//' @return \item{platform_index}{Integer identifying platform}
//' @return \item{device}{Character string listing device name}
//' @return \item{device_index}{Integer identifying device}
//' @return \item{device_type}{Character string labeling device (e.g. gpu)}
//' @export
// [[Rcpp::export]]
DataFrame 
listContexts()
{

    // declarations
    int id = 0;
    int num_contexts = 0;
    //int num_devices;
    typedef std::vector< viennacl::ocl::platform > platforms_type;
    
    // get platforms
    platforms_type platforms = viennacl::ocl::get_platforms();  
    
    Rcpp::Function msg = Rcpp::Environment::base_env()["packageStartupMessage"];
    
//    Rcout << "number of platforms found" << std::endl;
//    Rcout << platforms.size() << std::endl;
    
    // count number of contexts initialized
    // for each platform    
    for(unsigned int plat_idx=0; plat_idx < platforms.size(); plat_idx++){
        
        num_contexts += platforms[plat_idx].devices(CL_DEVICE_TYPE_ALL).size();
//        for(unsigned int gpu_idx=0; gpu_idx < platforms[plat_idx].devices().size(); gpu_idx++){
//            num_contexts++;
//        }
    }
    
    // need to multiply by number of platforms too
    // num_contexts *= platforms.size();
    
//    Rcout << "number of total contexts to create" << std::endl;
//    Rcout << num_contexts << std::endl;
    
    Rcpp::IntegerVector   context_index(num_contexts);
    Rcpp::CharacterVector platform_name(num_contexts);
    Rcpp::IntegerVector   platform_index(num_contexts);
    Rcpp::CharacterVector device_name(num_contexts);
    Rcpp::IntegerVector   device_index(num_contexts);
    Rcpp::CharacterVector device_type(num_contexts);
    
    for(unsigned int plat_idx = 0; plat_idx < platforms.size(); plat_idx++) {
        
        std::vector< viennacl::ocl::device > devices;
        devices = platforms[plat_idx].devices(CL_DEVICE_TYPE_ALL);
        
        for(unsigned int gpu_idx = 0; gpu_idx < devices.size(); gpu_idx++) {
        
//            Rcout << "context id" << std::endl;
//            Rcout << id << std::endl;
            
//            Rcout << "current platform index" << std::endl;
//            Rcout << plat_idx << std::endl;
            
            context_index[id] = id + 1;
            platform_index[id] = plat_idx;
            platform_name[id] = platforms[plat_idx].info();
            
//            viennacl::ocl::set_context_platform_index(id, plat_idx);
//            
////            Rcout << "set platform successfully" << std::endl;
//            
//            // Select device
//            viennacl::ocl::setup_context(id, devices[gpu_idx]);
//            
////            Rcout << "switched device successfully" << std::endl;
            
            // Get device info
            device_index[id] = 0;
            device_name[id] = devices[gpu_idx].name();
            // device_name[id] = viennacl::ocl::current_device().name();
            
//            Rcout << "current device index" << std::endl;
//            Rcout << device_index[id] << std::endl;
            
//            Rcout << "current device name" << std::endl;
//            Rcout << device_name[id] << std::endl;
            

	    cl_device_type check = devices[gpu_idx].type(); 
	    if(check & CL_DEVICE_TYPE_CPU){
		device_type[id] = "cpu";
	    }else if(check & CL_DEVICE_TYPE_GPU){
		device_type[id] = "gpu";
	    }else if(check & CL_DEVICE_TYPE_ACCELERATOR){
		device_type[id] = "accelerator";
	    }else{

	 	msg(Rcpp::wrap("device found: " + std::to_string(check)));
		
		throw Rcpp::exception("unrecognized device detected");
 
	    }

	    // increment context
            id++;
        }
    }
    
    return Rcpp::DataFrame::create(Rcpp::Named("context") = context_index,
    			  Rcpp::Named("platform") = platform_name,
                  Rcpp::Named("platform_index") = platform_index,
				  Rcpp::Named("device") = device_name,
                  Rcpp::Named("device_index") = device_index,
                  Rcpp::Named("device_type") = device_type,
                  _["stringsAsFactors"] = false );
}


//' @title Current Context
//' @description Get current context index
//' @return An integer reflecting the context listed in \link{listContexts}
//' @export
// [[Rcpp::export]]
int currentContext()
{
    return viennacl::ocl::backend<>::current_context_id() + 1;
}


// [[Rcpp::export]]
void
cpp_setContext(int id)
{
    if(id <= 0){
        stop("Index cannot be 0 or less");
    }
    viennacl::ocl::switch_context(id - 1);
}

// [[Rcpp::export]]
SEXP
getContextPtr(const int ctx_id){
    
    viennacl::ocl::context ctx(viennacl::ocl::get_context(ctx_id));
    Rcpp::XPtr<viennacl::ocl::context> ptrctx(&ctx);
    return ptrctx;
}


