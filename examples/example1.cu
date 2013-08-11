#include "../src/fdm3d.cuh"
#include "../macros/errors.h"
#include <stdlib.h>
#include <stdio.h>





void cubeCreator(uint size, float *input) {
    for(int i = 0;i < size; ++i) {
        for(int j = 0; j < size; ++j){
            for(int k = 0; k < size; ++k){
                if(i != 0)
                    input[k + j*size + i*size*size] = 0.0f;
                else
                    input[k + j*size + i*size*size] = 100.0f;

            }
        }
    }
}

const int SIZE = 130;
const int STEPS = 5e4;
const int BLOCK_SIZE =16 ;
/////////////////////////////////////////
void dump(const float * const input, int size, int I) {
    if(input) {
        for(int i = 0;i < size; ++i) {
            for(int j = 0; j < size; ++j){
                for(int k = 0; k < size; ++k){
                   if( k == I ){
                   printf("%d %d %d %f \n",k,j,i,input[k+ j*size + i*size*size]);
                   if(j == size -1)
                    printf("\n");
                }
                }
            }
        }


    }
}


int main () {

    float* h_input = (float*)malloc(sizeof(float) * SIZE * SIZE *SIZE);

    float* d_input;
    float* d_output;


    cubeCreator(SIZE,h_input);

    CHECK_ERROR(cudaMalloc((void**)(&d_input),sizeof(float) * SIZE*SIZE*SIZE));
    CHECK_ERROR(cudaMalloc((void**)(&d_output),sizeof(float) * SIZE*SIZE*SIZE));

    CHECK_ERROR(cudaMemcpy((void*)d_input,(void*)h_input,sizeof(float)*SIZE*SIZE*SIZE,cudaMemcpyHostToDevice));
    CHECK_ERROR(cudaMemcpy((void*)d_output,(void*)h_input,sizeof(float)*SIZE*SIZE*SIZE,cudaMemcpyHostToDevice));

    for(int i = 0; i < STEPS; ++i) {
        fdm3d<<<dim3(8,8,1),dim3(BLOCK_SIZE,BLOCK_SIZE,1),3*(sizeof(float)*(BLOCK_SIZE+2)*(BLOCK_SIZE+2))>>>(d_input,d_output,SIZE,SIZE,make_float3(0.005f,0.005f,0.005f));
        CHECK_ERROR(cudaDeviceSynchronize());

        float* d_temp = 0;
        d_temp = d_input;
        d_input = d_output;
        d_output = d_temp;

    }

    CHECK_ERROR(cudaMemcpy((void*)h_input,(void*)d_input,sizeof(float)*SIZE*SIZE*SIZE,cudaMemcpyDeviceToHost));

    dump(h_input,SIZE,SIZE/3);
    free(h_input);
    CHECK_ERROR(cudaFree(d_input));
    CHECK_ERROR(cudaFree(d_output));
    return 0;
}
