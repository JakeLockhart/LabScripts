#include <Arduino.h>
volatile int Counter = 0;
volatile bool Flag = false;

void FlagState() {
  Flag = true;
}

void CreatePulse() {
  Counter++;
  Serial.print(Counter);
  Flag = false;
}

void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT);
  pinMode(DAC0, OUTPUT);
  pinMode(7, OUTPUT);
  analogWriteResolution(12);
  
  attachInterrupt(digitalPinToInterrupt(2), FlagState, RISING);
}

void loop() {
  if (Flag) {
    CreatePulse();
  }
}