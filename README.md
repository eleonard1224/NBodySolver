# CUDA N-Body Solver 


## Compile Instructions
`nvcc main.cu nbody.cu video.cu -o nbody -I/usr/include/opencv4/ -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs -lopencv_videoio`

## Run Instructions
`./nbody`