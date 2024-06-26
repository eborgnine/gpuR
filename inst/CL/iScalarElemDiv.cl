__kernel void ScalarElemDiv(
    __global int *A, const int B,
    const int Mdim, const int Pdim, const int MdimPad) {

    const float Bfloat = B;
    
    // Get the index of the elements to be processed
    const int globalRow = get_global_id(0); // C Row ID
    const int globalCol = get_global_id(1); // C Col ID
    
    // Do the operation
    if((globalRow <= Mdim) && (globalCol <= Pdim)){
        
        A[globalRow * MdimPad + globalCol] = Bfloat/(
          (float) A[globalRow * MdimPad + globalCol]
        );
    }
}