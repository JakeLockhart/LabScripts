#include <Arduino.h>

int frameTrigger = 2;   // Pin number for the input (Frame Trigger) - Recieves input from MScan?
int pulseOutput = 7;    // Pin number for the output (Generated Pulse) - Where the TTL pulse is output
int currTrigNum = 2;    // Current trigger number (Imageing Plane _) - Tracks the imaging plane
int maxTrigNum = 2;     // Maximum number of triggers (Max Imaging Planes) - The total image planes to cycle over
void vSwitch();         // Declare function - Function to switch imaging plane based on trigger number

void setup() {
    pinMode(pulseOutput, OUTPUT);   // Set the 'pulseOutput' as the output pin - Output signal to ETL
    pinMode(frameTrigger, INPUT);   // Set the 'frameTrigger' as the input pin - Recieve signal from MScan
    attachInterrupt(digitalPinToInterrupt(frameTrigger), vSwitch, RISING);  // ?????
}

void loop() {}  //

void vSwitch() {                            // Create declared function (vSwitch)
    if (currTrigNum == 1) {                 // If you are on the last (bottom) imaging plane
        digitalWrite(pulseOutput, HIGH);        // Set voltage state to 'HIGH' - Set the voltage to 5V, which represents the 'on' state
        delayMicroseconds(5);                   // Create a delay time - Keep 'on' state for a period of time
        digitalWrite(pulseOutput, LOW);         // Set voltage state to 'LOW' - Set the voltage to 0V, which represents the 'off' state
        currTrigNum = maxTrigNum;               // Reset the trigger counter to the maximum trigger number - Reset the imaging plane to the top
    }
    else {                                  // If you are any other imaging plane
        currTrigNum--;                          // Decrement current trigger number - Move down one imaging plane
    }
}