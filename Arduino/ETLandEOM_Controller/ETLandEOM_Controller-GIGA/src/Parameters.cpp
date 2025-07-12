#include <Arduino.h>
#include "Parameters.h"
#define DAC0 A12

// User Inputs
    // What wavelength are you using?
    // How many imaging planes will you be imaging?
    // What are the imaging plane depths (um)?
int Wavelength = 920;
int TotalImagingPlanes = 10; 
int ImagingPlaneDepths[MAX_Planes] = {1,2,3,4,5,6,7,8,9,10};
int InputIntensity[MAX_Planes] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100}; // TO BE REPLACED WITH A FUNCTION!!!!

//---------------------- Do Not Edit --------------------------------------------------------------
// Arduino Board Pins (TTL Input/Output)
int NewLine_MScan = 2;      // Income TTL pulse from MScan that occurs at every new line
int NewFrame_MScan = 3;     // Income TTL pulse from MScan that occurs at every new frame
int TTLPulse_ETL = 7;       // Outgoing TTL pulse to Gardasoft, then ETL 
int TTLPulse_EOM = DAC0;    // Outgoing TTL pulse to Amplifier (J3 port) to control EOM (Pockel Cell)

// Declare derivative/constant variables
int PulseWidth = 37;
int PulseGap = 0;
float ReferenceVoltage = 3.3;
int VoltageStepIndex = 0;
int CurrentImagingPlane = TotalImagingPlanes;
volatile int FrameCounter = 0;
volatile bool EOMFlag = false;
volatile bool ETLFlag = false;
float LaserIntensity[MAX_Planes];
float LaserVoltage[MAX_Planes];
float LaserVoltage_Bits[MAX_Planes];