#include <Arduino.h>
#include "Parameters.h"

// User Inputs
    // What wavelength are you using?
    // How many imaging planes will you be imaging?
    // What are the imaging plane depths (um)?
int Wavelength = 920;
int TotalImagingPlanes = 3; 
int ImagingPlaneDepths[MAX_Planes] = {1,2, 3};
int InputIntensity[MAX_Planes] = {25, 50, 100}; // TO BE REPLACED WITH A FUNCTION!!!!

//---------------------- Do Not Edit --------------------------------------------------------------
// Arduino Board Pins (TTL Input/Output)
int NewFrame_MScan = 2; // Income TTL pulse from MScan that occurs at every new frame
int TTLPulse_ETL = 7;   // Outgoing TTL pulse to Gardasoft, then ETL 
int TTLPulse_EOM = DAC0;   // Outgoing TTL pulse to Amplifier (J3 port) to control EOM (Pockel Cell)

// Declare derivative/constant variables
int Delay = 100;
float ReferenceVoltage = 3.3;
int CurrentImagingPlane = TotalImagingPlanes;
float LaserIntensity[MAX_Planes];
float LaserVoltage[MAX_Planes];
float LaserVoltage_Bits[MAX_Planes];