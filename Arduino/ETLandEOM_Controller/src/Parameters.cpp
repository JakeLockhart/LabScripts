#include <Arduino.h>
#include "Parameters.h"

const int TotalImagingPlanes = 3;
float ImagingDepth[TotalImagingPlanes] = {12.2, 33, 60};
float InputIntensity[TotalImagingPlanes];
float ImagingPower[TotalImagingPlanes];

float Delay = 5;

int Wavelength = 920;
