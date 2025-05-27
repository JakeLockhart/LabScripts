#include <Arduino.h>

// Pin Definitions
const int LineOutPin = 2;
const int FrameOutPin = 3;

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


