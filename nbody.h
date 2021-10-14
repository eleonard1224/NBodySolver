// Header file for nbody cuda calls
#ifndef NBODY
#define NBODY

#include <iostream>
#include <math.h>
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

#define EPS2 1.0e-5

__global__ void calculate_positions(void *devX, void *devV, void *devA, void *posR, int N, int p, int nt, float dt);
__device__ void calculate_forces(void *devX, void *devV, void *devA, float4 *globalR, int N, int p, int it, float dt);
__device__ float3 bodyBodyInteraction(float4 bi, float4 bj, float3 ai);
__device__ float3 tile_calculation(float4 myPosition, float3 accel);
__device__ inline float4& operator +=(float4& a, const float4& b);
__device__ inline float4 operator *(const float4& a, const float& b);
__device__ inline float4 operator +(const float4& a, const float4& b);

#endif