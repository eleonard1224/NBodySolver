// Header file for opencv video calls
#ifndef VIDEO
#define VIDEO

#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;
using namespace std;

Mat create_image(float *posR, int N, int it, float W, float H, int pixel_width, int pixel_height);

#endif