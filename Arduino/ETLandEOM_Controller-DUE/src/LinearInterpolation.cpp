#include "LinearInterpolation.h"

// Create linear interpolation function
float LinearInterpolation(float x, float x0, float y0, float x1, float y1) {
    float t = (x - x0) / (x1 - x0);
    return (1 - t) * y0 + t * y1;
}