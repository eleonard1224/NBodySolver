// main file for nbody functions
#include <iostream>
#include <math.h>
#include "nbody.h"
#include "video.h"

int main(void) {

    int N = 4; // Number of particles
    float *devX, *devV, *devA; // Arrays which hold positions, velocities, and accelerations of particles
    float *posR; // posR has 4*N_particles*N_time_steps entries - stores the locations of the particles over all the timesteps
    int nt = 160; // Number of time steps
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
    float c1 = 5.0f;
    float c2 = -5.0f;
    devX[0] = c1; devX[1] = c1; devX[3] = 1.0f; // Particle # 1
    devX[4] = c2; devX[5] = c1; devX[7] = 1.0f; // Particle # 2
    devX[8] = c2; devX[9] = c2; devX[11] = 1.0f; // Particle # 3
    devX[12] = c1; devX[13] = c2; devX[15] = 1.0f; // Particle # 4
    // Copy over initial positions of particles to posR
    // posR[0] = devX[0]; posR[1] = devX[1]; posR[2] = devX[2];
    // posR[4] = devX[4]; posR[5] = devX[5]; posR[6] = devX[6];
    for(i = 0; i < 4*N; i += 4) {
        for(j = 0; j < 3; j++) {
            posR[i+j] = devX[i+j];
        }
    }

    // Run the function on using the GPU.
    calculate_positions<<<N, 2, N*sizeof(float4)>>>(devX, devV, devA, posR, N, 1, nt, dt); 
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

    create_video(posR, N, nt, 20.0f, 20.0f, 512, 512, "test.avi");
    // Mat img = create_image(posR, N, 0, 5.0f, 5.0f, 512, 512);
}