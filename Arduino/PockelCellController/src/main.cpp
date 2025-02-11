#include <Arduino.h>

int x;
int y;

// Function prototype
void myFunction(int x, int y);  // Declare the function before using it

void setup() {
  // Initialize serial communication
  Serial.begin(9600); // Initialize serial communication at 9600 baud
  x = 1;
  y = 3;
}

void loop() {
  // Call the function to print to Serial Monitor
  myFunction(x, y);
  delay(1000); // Delay between prints
}

// Function definition
void myFunction(int x, int y) {
  Serial.print("This is a test: ");
  Serial.println(x + y);  // Prints the sum of x and y
}
