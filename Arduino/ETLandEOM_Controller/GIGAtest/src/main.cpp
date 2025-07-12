#include <Arduino.h>
#define DAC0 A12

volatile int counter = 0;

int BrokenPin = 2;

void setup() {
    pinMode(BrokenPin, OUTPUT);
}
void loop() {
    digitalWrite(BrokenPin, HIGH);
    delayMicroseconds(100);
    digitalWrite(BrokenPin, LOW);
    delayMicroseconds(100);
}



