// main file for nbody functions
#include <iostream>
#include <math.h>
#include "nbody.h"
#include "video.h"

int main(void) {

    int N = 2; // Number of particles
    float *devX, *devV, *devA; // Arrays which hold positions, velocities, and accelerations of particles
    float *posR; // posR has 4*N_particles*N_time_steps entries - stores the locations of the particles over all the timesteps
    int nt = 4; // Number of time steps
    float dt = 0.1f; // Time step size

    // Allocate Unified Memory – accessible from CPU or GPU
    cudaMallocManaged(&devX, 4*N*sizeof(float));
    cudaMallocManaged(&devV, 4*N*sizeof(float));
    cudaMallocManaged(&devA, 4*N*sizeof(float));
    cudaMallocManaged(&posR, 4*N*nt*sizeof(float));

    // Initialize devX, devV, and devA arrays with zero floats.
    int i, j;
    for (i = 0; i < 4*N; i++) {
        devX[i] = 0.0f;
        devV[i] = 0.0f;
        devA[i] = 0.0f;
    }
    // Set Initial Positions of Particles
    devX[0] = 1.0f; devX[3] = 1.0f; devX[4] = -1.0f; devX[7] = 1.0f;
    // Copy over initial positions of particles to posR
    // posR[0] = devX[0]; posR[1] = devX[1]; posR[2] = devX[2];
    // posR[4] = devX[4]; posR[5] = devX[5]; posR[6] = devX[6];
    for(i = 0; i < 4*N; i += 4) {
        for(j = 0; j < 3; j++) {
            posR[i+j] = devX[i+j];
        }
    }

    // Run the function on using the GPU.
    calculate_positions<<<2, 1, N*sizeof(float4)>>>(devX, devV, devA, posR, N, 1, nt, dt); 
    cudaDeviceSynchronize();

    // // Print-outs for testing purposes
    // cout << "Accelerations" << endl;
    // for (int i = 0; i < 4*N; i++) {
    //     cout << devA[i] << " ";
    // }
    // cout << endl;

    // cout << "Positions" << endl;
    // for (int i = 0; i < 4*N*nt; i++) {
    //     cout << posR[i] << " ";
    // }
    // cout << endl;

    Mat img = create_image(posR, N, 0, 5.0f, 5.0f, 512, 512);
}