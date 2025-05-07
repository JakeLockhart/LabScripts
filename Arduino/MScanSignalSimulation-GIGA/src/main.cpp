#include <Arduino.h>

// Pin definitions
const int Potentiometer = A0;
const int Analog_Output = A12;

// Parameters
const int PulseWidth = 40;          // Pulse width in microseconds
const int PulseGap   = 25;          // Gap between pulses

const int VoltageMin = 0;           // Minimum voltage in mV (DAC lower limit)
const int VoltageMax = 3300;        // Desired max output in mV (user-controlled)
const float DAC_Reference = 3300.0; // Full-scale DAC voltage in mV (3.3V)

// Convert voltage to 12-bit DAC value
int voltageToDacBits(int mV) {
  return (int)((float)mV / DAC_Reference * 4095);
}
int DAC_Min_Bits = voltageToDacBits(VoltageMin);
int DAC_Max_Bits = voltageToDacBits(VoltageMax);

void setup() {
  pinMode(Potentiometer, INPUT);
  pinMode(Analog_Output, OUTPUT);
  pinMode(7, OUTPUT);

  analogReadResolution(12);
  analogWriteResolution(12);
}

void loop() {
  int PValue = analogRead(Potentiometer);

  int DAC_Output = map(PValue, 0, 4095, DAC_Min_Bits, DAC_Max_Bits);    // Map potentiometer to DAC range
  DAC_Output = constrain(DAC_Output, DAC_Min_Bits, DAC_Max_Bits);       // Constrain voltage output

  analogWrite(Analog_Output, 4000);   // Create pulse
  digitalWrite(7,HIGH);
  delayMicroseconds(PulseWidth);
  analogWrite(Analog_Output, 0);
  digitalWrite(7, LOW);
  delayMicroseconds(PulseGap);
}
