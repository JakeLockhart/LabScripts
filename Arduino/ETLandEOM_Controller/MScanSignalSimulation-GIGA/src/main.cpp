//#include <Arduino.h>
//
//// Pin definitions
//const int Potentiometer = A0;
//const int Analog_Output = A12;
//const int FrameOut = 3;
//const int LineOut = 2;
//
//// Parameters
//const int PulseWidth = 40;          // Pulse width in microseconds
//const int PulseGap   = 25;          // Gap between pulses
//
//const int VoltageMin = 0;           // Minimum voltage in mV (DAC lower limit)
//const int VoltageMax = 3300;        // Desired max output in mV (user-controlled)
//const float DAC_Reference = 3300.0; // Full-scale DAC voltage in mV (3.3V)
//
//// Convert voltage to 12-bit DAC value
//int voltageToDacBits(int mV) {
//  return (int)((float)mV / DAC_Reference * 4095);
//}
//int DAC_Min_Bits = voltageToDacBits(VoltageMin);
//int DAC_Max_Bits = voltageToDacBits(VoltageMax);
//
//void setup() {
//  pinMode(Potentiometer, INPUT);
//  pinMode(Analog_Output, OUTPUT);
//  pinMode(FrameOut, OUTPUT);
//  pinMode(LineOut, OUTPUT);
//
//  analogReadResolution(12);
//  analogWriteResolution(12);
//}
//
//void loop() {
//  //int PValue = analogRead(Potentiometer);
//  //int DAC_Output = map(PValue, 0, 4095, DAC_Min_Bits, DAC_Max_Bits);    // Map potentiometer to DAC range
//  //DAC_Output = constrain(DAC_Output, DAC_Min_Bits, DAC_Max_Bits);       // Constrain voltage output
//
//  digitalWrite(FrameOut, HIGH);
//  delayMicroseconds(4);
//
//}

#include <Arduino.h>

// Pin Definitions
const int FrameOutPin = 2;
const int LineOutPin = 3;

void setup() {
  pinMode(FrameOutPin, OUTPUT);
  pinMode(LineOutPin, OUTPUT);
  digitalWrite(FrameOutPin, LOW);
  digitalWrite(LineOutPin, LOW);
}

void loop() {
  digitalWrite(FrameOutPin, HIGH);
  delayMicroseconds(4);
  for (int i = 0; i < 5; i++) {
    digitalWrite(LineOutPin, HIGH);
    delayMicroseconds(40);
    digitalWrite(LineOutPin, LOW);
    delayMicroseconds(8);
  }
  digitalWrite(FrameOutPin, LOW);
  for (int i = 0; i < 512; i++) {
    digitalWrite(LineOutPin, HIGH);
    delayMicroseconds(40);
    digitalWrite(LineOutPin, LOW);
    delayMicroseconds(8);
  }
}


