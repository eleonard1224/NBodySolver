// Implementation of video calls
#include "video.h"

Mat create_image(float *posR, int N, int it, float W, float H, int pixel_width, int pixel_height) {

    int i;
    int px, py;
    int idx = 4*N*it; // Starting position index for timestep it
    Mat img(pixel_width, pixel_height, CV_8UC3, Scalar(0,0,0));
    for(i = idx; i < idx + 4*N; i += 4) {
        // printf("posR[i] = %f, posR[i+1] = %f\n", posR[i], posR[i+1]);
        px = (int) (((posR[i]+(W/2.0))/((float) W))*((float) pixel_width));
        py = (int) (((posR[i+1]+(H/2.0))/((float) W))*((float) pixel_height));
        circle(img, Point(px,py),10, Scalar(255,255,255),-1, 8,0);
        // printf("px = %d, py = %d\n", px, py);
    }
    // circle(img, Point(50,50),10, Scalar(255,255,255),-1, 8,0);
    imwrite("test.png", img); // Test
    return img;
}