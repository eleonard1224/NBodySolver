# CUDA N-Body Solver 
This repository contains CUDA code which parallelizes the solution of the N-body problem in which N particles exert gravitational forces on one another.  The CUDA code in `nbody.cu` was taken from an NVIDIA blog and then adapted to create video of the trajectories of particles in motion acted on by gravitational forces.  The example programmed into `main.cu` generates `particles.mp4` in which four particles are originally placed at the corners of a square.  Due to the parallel construction and usage of the the N-body algorithm, the grid must be synchronized after each call to `calculate_forces` in `nbody/calculate_positions` if the grid contains multiple blocks.  With later NVIDIA GPU architectures, the Cooperative Groups functionality can be used to synchronize the entire grid. 

## Compile Instructions
`nvcc main.cu nbody.cu video.cu -o nbody -I/usr/include/opencv4/ -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs -lopencv_videoio`

## Run Instructions
`./nbody`