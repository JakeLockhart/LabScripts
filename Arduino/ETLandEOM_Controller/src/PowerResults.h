#ifndef PowerResults_h
#define PowerResults_h

struct WavelengthList {
    int Wavelengths[4];
};
struct PowerResults {
    float InputIntensity;
    float LaserIntensity[4];
};
extern WavelengthList data_WavelengthList[]; // Declare WavelengthList as external
extern PowerResults data_PowerResults[]; // Declare PowerResults as external
extern const int data_WavelengthList_size; // Add a constant for the size of WavelengthList
extern const int data_PowerResults_size;  // Add a constant for the size of PowerResults 

#endif