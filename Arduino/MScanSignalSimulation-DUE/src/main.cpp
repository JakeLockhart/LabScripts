#include <Arduino.h>

// Arduino Due Board Pins
int Potentiometer = A0;
int MScanOutput = DAC0;

// Parameters
int TTL_Amplitude = 700;    // Desired amplitude [mV]
int PPAdjust = 100;         // Fine tuning range [±50mV]
int PulseWidth = 100;       // Pulse width duration [um]
int PulseGap = 100;         // Pulse gap duration [um]
int TuneRange = 600;        // Fine-tuning range for potentiometer [±100mV]
int Amplitude_Bits = map(TTL_Amplitude, 550, 3300, 0, 4095);    // Convert Amplitude from mV to DAC (0.5-3.3V = 0-4095)


void setup() {
    pinMode(MScanOutput, OUTPUT);   // Setup pins
    analogWriteResolution(12);      // Read/Write resolution is 12-bits
    pinMode(Potentiometer, INPUT);
    analogReadResolution(12);    
}

void loop() {
    int PValue = analogRead(Potentiometer);                                         // Read potentiometer analog input value
    int TuneBits = map(PValue, 0, 4095, -TuneRange, TuneRange) * 4095 / (3300-550); // Map analog input to bit range and convert to mV range
    int MScanOutput_Amplitude = constrain(Amplitude_Bits + TuneBits, 0, 4095);      // Create boundaries so that analog input does not exceed DAC range

    analogWrite(MScanOutput, MScanOutput_Amplitude);    // Create TTL pulse
    delayMicroseconds(PulseWidth);
    analogWrite(MScanOutput, 0);
    delayMicroseconds(PulseGap);
}
