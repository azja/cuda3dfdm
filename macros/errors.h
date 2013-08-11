/*
* errors.h
*
* Created on: 23-03-2013
* Author: biborski
*/

#ifndef ERRORS_H_
#define ERRORS_H_

#define CHECK_ERROR(func) do { \
if( func!= cudaSuccess )\
fprintf(stderr,"Cuda error in %s: %s at %s:%i \n",#func, cudaGetErrorString(func), __FILE__, __LINE__); \
} while(0)

#endif /* ERRORS_H_ */
