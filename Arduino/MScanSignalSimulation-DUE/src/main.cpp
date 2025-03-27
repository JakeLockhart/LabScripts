#include <Arduino.h>

#define POT_PIN A0   // Potentiometer connected to A0
#define DAC_PIN DAC0 // DAC output pin

int Amplitude_mV = 700; // Desired amplitude in millivolts (mV)
int FineTuneRange_mV = 100; // Fine-tuning range ±50mV

void setup() {
    pinMode(POT_PIN, INPUT);
    pinMode(DAC_PIN, OUTPUT);
    analogReadResolution(12);  // 12-bit ADC (0-4095)
    analogWriteResolution(12); // 12-bit DAC (0-4095)
}

void loop() {
    // Convert Amplitude from mV to DAC units (0-4095 for 0-3.3V)
    int Amplitude_Bits = (Amplitude_mV * 4095) / 3300;

    // Read potentiometer value (0-4095) and map to fine-tune range
    int potValue = analogRead(POT_PIN);
    int fineTuneBits = map(potValue, 0, 4095, -FineTuneRange_mV, FineTuneRange_mV) * 4095 / 3300;

    // Apply fine-tuning, ensuring the value stays within DAC limits
    int outputValue = constrain(Amplitude_Bits + fineTuneBits, 0, 4095);

    // Generate square wave with fine-tuned amplitude
    analogWrite(DAC_PIN, outputValue);
    delayMicroseconds(100);
    analogWrite(DAC_PIN, 0);
    delayMicroseconds(100);
}
