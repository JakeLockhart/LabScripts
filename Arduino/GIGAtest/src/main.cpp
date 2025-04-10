#include <Arduino.h>

#define DAC0 A12

volatile int counter = 0;

//void myISR() {
//    analogWrite(DAC0, 1000);
//    digitalWrite(7, HIGH);
//    analogWrite(DAC0, 0);
//    digitalWrite(7,LOW);
//}
//
//void setup() {
//    Serial.begin(9600);
//    pinMode(2, INPUT);
//    pinMode(DAC0, OUTPUT);
//    analogWriteResolution(12);
//    attachInterrupt(digitalPinToInterrupt(2), myISR, RISING);
//}
//
//void loop() {
//    Serial.println(counter);
//    delay(100);
//}

//volatile bool updateDAC = false;  // Flag to trigger DAC update
//
//void myISR() {
//    updateDAC = true;  // Set flag inside ISR
//}
//
//void setup() {
//    pinMode(2, INPUT);  // Standard input mode since TTL actively drives the pin
//    pinMode(7, OUTPUT); // Output pin
//    analogWriteResolution(12); // Set DAC resolution to 12-bit
//    attachInterrupt(digitalPinToInterrupt(2), myISR, RISING); // Trigger on rising edge
//}
//
//void loop() {
//    if (updateDAC) {
//        analogWrite(A12, 1000);  // Output 1000 (out of 4095 for 12-bit DAC)
//        delayMicroseconds(10);   // Small delay
//        analogWrite(A12, 0);     // Reset to 0V
//        updateDAC = false;       // Clear flag
//    }
//}

void setup() {
    pinMode(7,OUTPUT);
}
void loop() {
    digitalWrite(7,HIGH);
    delayMicroseconds(100);
    digitalWrite(7,LOW);
    delayMicroseconds(100);
}



