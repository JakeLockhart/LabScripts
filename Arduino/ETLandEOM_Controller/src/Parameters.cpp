#include <Arduino.h>
#include "Parameters.h"

// User Inputs
    // What wavelength are you using?
    // How many imaging planes will you be imaging?
    // What are the imaging plane depths (um)?
int Wavelength = 920;
int TotalImagingPlanes = 4; 
int ImagingPlaneDepths[MAX_Planes] = {0, 50, 100, 250};
int InputIntensity[MAX_Planes] = {20, 33, 44, 100}; // TO BE REPLACED WITH A SPENCER'S FUNCTION!!!!

//---------------------- Do Not Edit --------------------------------------------------------------
// Arduino Board Pins (TTL Input/Output)
int NewFrame_MScan = 2; // Income TTL pulse from MScan that occurs at every new frame
int TTLPulse_ETL = 7;   // Outgoing TTL pulse to Gardasoft, then ETL
int TTLPulse_EOM = 8;   // Outgoing TTL pulse to Amplifier (J3 port) to control EOM (Pockel Cell)

// Declare derivative/constant variables
int Delay = 5;
int CurrentImagingPlane = 2;