#ifndef VoltageInterpolation_h
#define VoltageInterpolation_h
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "OscilloscopeVoltage.h"

void VoltageInterpolation(int Wavelength, int* MScanInput, int TotalPlanes, float* OutputVoltage);

#endif