#include <Arduino.h>
#include "Parameters.h"
#include "PowerInterpolation.h"
#include "VoltageInterpolation.h"
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "PowerResults.h"
#include "OscilloscopeVoltage.h"
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

void TestInterrupt(){
    digitalWrite(TTLPulse_ETL, HIGH);
    delayMicroseconds(Delay);
    digitalWrite(TTLPulse_ETL, LOW);
    Serial.println("Triggered");
}

void setup() {
    Serial.begin(9600);
    while (!Serial){};
    
    // Pin Setup 
        pinMode(NewFrame_MScan, INPUT);
        pinMode(TTLPulse_ETL, OUTPUT);
        pinMode(TTLPulse_EOM, OUTPUT);

    // Initialization
        PowerInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserIntensity);
        VoltageInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserVoltage);
        analogWriteResolution(12);
        for (int i = 0; i < TotalImagingPlanes; i++) {
            //LaserVoltage_Bits[i] = (LaserVoltage[i] / ReferenceVoltage) * 4095;
            LaserVoltage_Bits[i] = map(round(1000*LaserVoltage[i]),0,3300,0,4095);
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
        Serial.println("System Parameters:");
        Serial.print("\tLaser Output Bit(s): ");        for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(LaserVoltage_Bits[i]);
                                                            if (i < TotalImagingPlanes-1) Serial.print(",");
                                                        }
                                                        Serial.println();
        Serial.print("\tLaser Output Voltage(s): ");    for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(LaserVoltage[i], 4);
                                                            if (i < TotalImagingPlanes-1) Serial.print("V, ");
                                                        }
                                                        Serial.println("V");
        Serial.print("\tLaser Output Intensity(s): ");  for (int i = 0; i < TotalImagingPlanes; i++) {
                                                            Serial.print(LaserIntensity[i], 4);
                                                            if (i < TotalImagingPlanes-1) Serial.print("mW, ");
                                                        }
                                                        Serial.println("mW");

    // Interrupt
        //attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), InterruptHandler, RISING);
        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan),TestInterrupt, RISING); // WTF IS GOING WRONG???? CRASH OR UNRECOGNIZED????
}

void loop() {
}

