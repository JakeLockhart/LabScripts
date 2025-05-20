
#include <Arduino.h>
#include "Parameters.h"

void MonitorSerialOutput() {
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
                                                        if (i < TotalImagingPlanes-1) Serial.print(", ");
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
}