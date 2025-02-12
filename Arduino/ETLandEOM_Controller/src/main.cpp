#include <Arduino.h>
#include "PowerResults.h"
#include "OscilloscopeVoltage.h"
#include "PowerInterpolation.h"
//  This script is designed to control both the ETL and the EOM (Pockel Cell) in response to TTL pulses.
//      Parameters:
//          - Total imaging planes
//          - .txt file of R2P power measurement
//      Goal
//          - Create Gardasoft Code in response to total imaging planes & their respective depths
//          - Use .txt file as a reference to interpolate voltage/laser intensity at a specific imaging depth
//          - Adjust the ETL in response to a TTL pulse
//          - Adjust the EOM in response to a TTL pulse to match new focal depth(s)

// Define pin input(s)/output(s)
int NewFrame_MScan = 2;
int TTLPulse_ETL = 7;
int TTLPulse_EOM = 8;

// Define variables
int CurrentImagingPlane = 2;
int TotalImagingPlanes = 2;
int ImagingDepth[2] = {2,3};
int ImagingPower = {0};
int Delay = 5;

int Wavelength = 920;
float InputIntensity = 32;

// Define functions
float TESTTEST = PowerInterpolation(Wavelength, InputIntensity);
void ChangePlane(int CurrentImagingPlane, int TotalImagingPlanes,int TTLPulse_ETL, int Delay);
//void ChangePower();



void setup() {
    Serial.begin(9600);
    Serial.print("Wavelength [nm]: "); Serial.println(Wavelength);
    Serial.print("Input Intensity(s) [%]: "); Serial.println(InputIntensity);
    Serial.print("Laser Intensity [mW]: "); Serial.println(TESTTEST);
    Serial.print("Total Imaging Planes: "); Serial.println(TotalImagingPlanes);
    Serial.print("Imaging Plane Depths: "); 
        for (int i = 0; i < TotalImagingPlanes; i++) {
            Serial.print(ImagingDepth[i]); Serial.print("um ");}; Serial.println("");

    pinMode(NewFrame_MScan, INPUT);
    pinMode(TTLPulse_ETL, OUTPUT);
    pinMode(TTLPulse_EOM, OUTPUT);

    //attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), ChangePlane(CurrentImagingPlane, TotalImagingPlanes, TTLPulse_ETL, Delay), RISING);
    
}

void loop() {}
