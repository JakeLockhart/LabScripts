//#include <Arduino.h>
//#include "Parameters.h"
//#include "Wavelengths.h"
//#include "LinearInterpolation.h"
//#include "PowerResults.h"
//#include "OscilloscopeVoltage.h"
//#include "VoltageInterpolation.h"
//#include "PowerInterpolation.h"
//#include "ChangePV.h"
//#include "InterruptHandler.h"
//
////  This script is designed to control both the ETL and the EOM (Pockel Cell) in response to TTL pulses.
////      Parameters:
////          - Total imaging planes
////          - .txt file of R2P power measurement
////      Goal
////          - Create Gardasoft Code in response to total imaging planes & their respective depths
////          - Use .txt file as a reference to interpolate voltage/laser intensity at a specific imaging depth
////          - Adjust the ETL in response to a TTL pulse
////          - Adjust the EOM in response to a TTL pulse to match new focal depth(s)
//
//
//void setup() {
//    Serial.begin(9300);
//    
//    // Pin Setup 
//        pinMode(NewFrame_MScan, INPUT);
//        pinMode(TTLPulse_ETL, OUTPUT);
//        pinMode(TTLPulse_EOM, OUTPUT);
//
//    // Initialization
//        PowerInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserIntensity);
//        VoltageInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserVoltage);
//        analogWriteResolution(12);
//        for (int i = 0; i < TotalImagingPlanes; i++) {
//            LaserVoltage_Bits[i] = (LaserVoltage[i] / ReferenceVoltage) * 4095;
//        }
//        
//    // Intitialization Serial Output
//
//        Serial.println();
//        Serial.println("User Defined Parameters:");
//        Serial.print("\tLaser Wavelength: ");           Serial.println(Wavelength);
//        Serial.print("\tTotal Imaging Plane(s): ");     Serial.println(TotalImagingPlanes);
//        Serial.print("\tImaging Plane Depth(s): ");     for (int i = 0; i < TotalImagingPlanes; i++) {
//                                                            Serial.print(InputIntensity[i]);
//                                                            if (i < TotalImagingPlanes - 1) Serial.print("um, ");
//                                                        }
//                                                        Serial.println("um");
//        Serial.print("\tLaser Input Percentage(s): ");  for (int i = 0; i < TotalImagingPlanes; i++) {
//                                                            Serial.print(InputIntensity[i]);
//                                                            if (i < TotalImagingPlanes - 1) Serial.print("%, ");
//                                                        }
//                                                        Serial.println("%");
//        Serial.print("\tLaser Output Intensity(s): ");  for (int i = 0; i < TotalImagingPlanes; i++) {
//                                                            Serial.print(LaserIntensity[i], 4);
//                                                            if (i < TotalImagingPlanes-1) Serial.print("mW, ");
//                                                        }
//                                                        Serial.println("mW");
//        Serial.print("\tLaser Output Voltage(s): ");    for (int i = 0; i < TotalImagingPlanes; i++) {
//                                                            Serial.print(LaserVoltage[i], 4);
//                                                            if (i < TotalImagingPlanes-1) Serial.print("mV, ");
//                                                        }
//                                                        Serial.println("mV");
//        Serial.println(LaserVoltage_Bits[0]);
//        Serial.println(LaserVoltage_Bits[1]);
//
//    // Interrupt
//        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), InterruptHandler, RISING);
//}
//
//void loop() {
//}

#include <Arduino.h>
/*
  Blink

  Turns an LED on for one second, then off for one second, repeatedly.

  Most Arduinos have an on-board LED you can control. On the UNO, MEGA and ZERO
  it is attached to digital pin 13, on MKR1000 on pin 6. LED_BUILTIN is set to
  the correct LED pin independent of which board is used.
  If you want to know what pin the on-board LED is connected to on your Arduino
  model, check the Technical Specs of your board at:
  https://www.arduino.cc/en/Main/Products

  modified 8 May 2014
  by Scott Fitzgerald
  modified 2 Sep 2016
  by Arturo Guadalupi
  modified 8 Sep 2016
  by Colby Newman

  This example code is in the public domain.

  https://www.arduino.cc/en/Tutorial/BuiltInExamples/Blink
*/

// the setup function runs once when you press reset or power the board
void setup() {
    // initialize digital pin LED_BUILTIN as an output.
    pinMode(LED_BUILTIN, OUTPUT);
  }
  
  // the loop function runs over and over again forever
  void loop() {
    digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
    delay(1000);                      // wait for a second
    digitalWrite(LED_BUILTIN, LOW);   // turn the LED off by making the voltage LOW
    delay(1000);                      // wait for a second
  }
  