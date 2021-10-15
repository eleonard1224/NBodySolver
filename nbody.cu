// Implementation of nbody cuda calls
#include "nbody.h"

__global__ void calculate_positions(void *devX, void *devV, void *devA, void *posR, int N, int p, int nt, float dt) {

    float4 *globalR = (float4 *) posR;
    int it;
    for(it = 1; it < nt; it++) {
        calculate_forces(devX, devV, devA, globalR, N, p, it, dt);
    }
}

__device__ void calculate_forces(void *devX, void *devV, void *devA, float4 *globalR, int N, int p, int it, float dt) { 

    extern __shared__ float4 shPosition[];    
    float4 *globalX = (float4 *)devX;  
    float4 *globalV = (float4 *)devV;    
    float4 *globalA = (float4 *)devA;   
    float4 myPosition;   
    int i, tile;   
    float3 acc = {0.0f, 0.0f, 0.0f};   
    int gtid = blockIdx.x * blockDim.x + threadIdx.x;   
    myPosition = globalX[gtid];
    for (i = 0, tile = 0; i < N; i += p, tile++) { 
        int idx = tile * blockDim.x + threadIdx.x; 
        shPosition[threadIdx.x] = globalX[idx];   
        __syncthreads();     
        acc = tile_calculation(myPosition, acc); 
        __syncthreads();   
    }
    float4 acc4 = {acc.x, acc.y, acc.z, 0.0f};   
    globalA[gtid] = acc4; 
    globalX[gtid] = globalX[gtid] + globalV[gtid]*dt + globalA[gtid]*dt*0.5f;
    globalV[gtid] += (acc4*dt); 
    globalR[N*it+gtid] = globalX[gtid];
} 

__device__ float3 tile_calculation(float4 myPosition, float3 accel) {   

    int i;   
    extern __shared__ float4 shPosition[];    
    for (i = 0; i < blockDim.x; i++) {     
        accel = bodyBodyInteraction(myPosition, shPosition[i], accel);   
    }
    return accel; 
} 

__device__ float3 bodyBodyInteraction(float4 bi, float4 bj, float3 ai) {   

    float3 r;   
    r.x = bj.x - bi.x;   r.y = bj.y - bi.y;   r.z = bj.z - bi.z; 
    float distSqr = r.x * r.x + r.y * r.y + r.z * r.z + EPS2;   
    float distSixth = distSqr * distSqr * distSqr;   
    float invDistCube = 1.0f/sqrtf(distSixth);   
    float s = bj.w * invDistCube;   
    ai.x += r.x * s;   ai.y += r.y * s;   ai.z += r.z * s;   
    return ai; 
} 

__device__ inline float4& operator +=(float4& a, const float4& b) {
    a.x += b.x;
    a.y += b.y;
    a.z += b.z;
    a.w += b.w;
    return a;
}

__device__ inline float4 operator +(const float4& a, const float4& b) {
    float4 c;
    c.x = a.x + b.x;
    c.y = a.y + b.y;
    c.z = a.z + b.z;
    c.w = a.w + b.w;
    return c;
}

__device__ inline float4 operator *(const float4& a, const float& b) {
    float4 c;
    c.x = b*a.x;
    c.y = b*a.y;
    c.z = b*a.z;
    c.w = b*a.w;
    return c;
}