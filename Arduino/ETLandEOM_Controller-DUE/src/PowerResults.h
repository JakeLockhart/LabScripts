#ifndef PowerResults_h
#define PowerResults_h

struct PowerResults {
    float InputIntensity;
    float LaserIntensity[4];
};
extern PowerResults data_PowerResults[]; // Declare PowerResults as external
extern const int data_PowerResults_size;  // Add a constant for the size of PowerResults 

#endif