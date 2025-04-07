#include <Arduino.h>

// Arduino Due Board Pins
int Potentiometer = A0;
int Analog_Output = DAC0;
int Digital_Output = 7;

// Parameters
int TTL_Amplitude = 0;    // Desired amplitude [mV]
int PPAdjust = 100;         // Fine tuning range [±50mV]
int PulseWidth = 100;       // Pulse width duration [um]
int PulseGap = 25;         // Pulse gap duration [um]
int TuneRange = 1000;        // Fine-tuning range for potentiometer [±100mV]
int Amplitude_Bits = map(TTL_Amplitude, 550, 3300, 0, 4095);    // Convert Amplitude from mV to DAC (0.5-3.3V = 0-4095)


void setup() {
    pinMode(Analog_Output, OUTPUT);   // Setup pins
    analogWriteResolution(12);      // Read/Write resolution is 12-bits
    pinMode(Potentiometer, INPUT);
    analogReadResolution(12);    
    pinMode(Digital_Output, OUTPUT);
}

void loop() {
    int PValue = analogRead(Potentiometer);                                         // Read potentiometer analog input value
    int TuneBits = map(PValue, 0, 4095, -TuneRange, TuneRange) * 4095 / (3300-550); // Map analog input to bit range and convert to mV range
    int Analog_Output_Amplitude = constrain(Amplitude_Bits + TuneBits, 0, 4095);      // Create boundaries so that analog input does not exceed DAC range

    analogWrite(Analog_Output, Analog_Output_Amplitude);    // Create analog pulse
    digitalWrite(Digital_Output, HIGH);
    delayMicroseconds(PulseWidth);
    analogWrite(Analog_Output, 0);
    digitalWrite(Digital_Output, LOW);
    delayMicroseconds(PulseGap);
    
}
