// Header file for opencv video calls
#ifndef VIDEO
#define VIDEO

#include <iostream>
#include <string>
#include <vector>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/videoio.hpp>

using namespace cv;
using namespace std;

void create_video(float *posR, int N, int nt, float W, float H, int pixel_width, int pixel_height, string video_name);

Mat create_image(float *posR, int N, int it, float W, float H, int pixel_width, int pixel_height);

#endif