#include <Arduino.h>

#define DAC0 A12

int pulseWidth = 100;
int pulseGap = 200;
int values[] = {100, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000}; 

void setup() {
  pinMode(DAC0, OUTPUT);
  analogWriteResolution(12); 
}

void loop() {
  for (int i = 0; i < sizeof(values) / sizeof(values[0]); i++) {
    analogWrite(DAC0, values[i]);
    delay(pulseWidth);
    analogWrite(DAC0, 0);
    delay(pulseGap);
  }
}
