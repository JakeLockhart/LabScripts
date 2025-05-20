#ifndef Wavelengths_h
#define Wavelengths_h

struct WavelengthList {
    int Wavelengths[4];
};

extern WavelengthList data_WavelengthList[]; // Declare WavelengthList as external
extern const int data_WavelengthList_size; // Add a constant for the size of WavelengthList

#endif