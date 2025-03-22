#include <Arduino.h>
#include "Parameters.h"
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "PowerResults.h"
#include "OscilloscopeVoltage.h"
#include "VoltageInterpolation.h"
#include "PowerInterpolation.h"
#include "ChangePV.h"
#include "InterruptHandler.h"

//  This script is designed to control both the ETL and the EOM (Pockel Cell) in response to TTL pulses.
//      Parameters:
//          - Total imaging planes
//          - .txt file of R2P power measurement
//      Goal
//          - Create Gardasoft Code in response to total imaging planes & their respective depths
//          - Use .txt file as a reference to interpolate voltage/laser intensity at a specific imaging depth
//          - Adjust the ETL in response to a TTL pulse
//          - Adjust the EOM in response to a TTL pulse to match new focal depth(s)


void setup() {
    Serial.begin(9300);
    
    // Pin Setup 
        pinMode(NewFrame_MScan, INPUT);
        pinMode(TTLPulse_ETL, OUTPUT);
        pinMode(TTLPulse_EOM, OUTPUT);

    // Initialization
        PowerInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserIntensity);
        VoltageInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserVoltage);
        analogWriteResolution(12);
        for (int i = 0; i < TotalImagingPlanes; i++) {
            LaserVoltage_Bits[i] = (LaserVoltage[i] / ReferenceVoltage) * 4095;
        }
        
    // Intitialization Serial Output

        Serial.println();
        Serial.println("User Defined Parameters:");
        Serial.print("\tLaser Wavelength: ");           Serial.println(Wavelength);
        Serial.print("\tTotal Imaging Plane(s): ");     Serial.println(TotalImagingPlanes);
        Serial.print("\tImaging Plane Depth(s): ");     for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(InputIntensity[i]);
                                                            if (i < TotalImagingPlanes - 1) Serial.print("um, ");
                                                        }
                                                        Serial.println("um");
        Serial.print("\tLaser Input Percentage(s): ");  for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(InputIntensity[i]);
                                                            if (i < TotalImagingPlanes - 1) Serial.print("%, ");
                                                        }
                                                        Serial.println("%");
        Serial.print("\tLaser Output Intensity(s): ");  for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(LaserIntensity[i], 4);
                                                            if (i < TotalImagingPlanes-1) Serial.print("mW, ");
                                                        }
                                                        Serial.println("mW");
        Serial.print("\tLaser Output Voltage(s): ");    for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(LaserVoltage[i], 4);
                                                            if (i < TotalImagingPlanes-1) Serial.print("mV, ");
                                                        }
                                                        Serial.println("mV");
        Serial.println(LaserVoltage_Bits[0]);
        Serial.println(LaserVoltage_Bits[1]);

    // Interrupt
        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), InterruptHandler, RISING);
}

void loop() {
}