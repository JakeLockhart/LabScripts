#include <Arduino.h>
#include <PowerResults.h>
//  This script is designed to control both the ETL and the EOM (Pockel Cell) in response to TTL pulses.
//      Parameters:
//          - Total imaging planes
//          - .txt file of R2P power measurement
//      Goal
//          - Create Gardasoft Code in response to total imaging planes & their respective depths
//          - Use .txt file as a reference to interpolate voltage/laser intensity at a specific imaging depth
//          - Adjust the ETL in response to a TTL pulse
//          - Adjust the EOM in response to a TTL pulse to match new focal depth(s)

//int NewFrame_MScan = 2;
//int TTLPulse_ETL = 7;
//int TTLPulse_EOM = 8;
//
//
//int CurrentImagingPlane = 2;
//int TotalImagingPlanes = 2;
//int ImagingDepth = 0;
//int ImagingPower = 0;
//
//void PowerMeasure();
//void ChangePlane();
//void ChangePower();
//
//
//
//
//void setup(){}
//void loop(){}


// Function to interpolate the output intensities based on the input laser intensity
float interpolateIntensity(float InputIntensity) {
    // Loop through the data to find the closest laser intensity range
    for (int i = 0; i < sizeof(data)/sizeof(data[0]) - 1; i++) {
        if (InputIntensity >= data[i].InputIntensity && InputIntensity <= data[i + 1].InputIntensity) {
            // Perform linear interpolation for each output intensity
            float slope[4];
            for (int j = 0; j < 4; j++) {
                slope[j] = (data[i + 1].LaserIntensity[j] - data[i].LaserIntensity[j]) /
                           (data[i + 1].InputIntensity - data[i].InputIntensity);
            }
            float result[4];
            for (int j = 0; j < 4; j++) {
                result[j] = data[i].LaserIntensity[j] + slope[j] * (InputIntensity - data[i].InputIntensity);
            }
            return result[0];  // Return the first interpolated value (you can change this)
        }
    }
    return -1;  // Return -1 if the laser intensity is out of bounds
}

void setup() {
    Serial.begin(9600);

    // Example: Get a laser intensity input (from serial or pre-defined)
    float InputIntensity = 30.0;  // Example laser intensity

    // Interpolate the output intensity for the selected laser intensity
    float LaserIntensity = interpolateIntensity(InputIntensity);

    // Output the result
    Serial.print("Laser Intensity: ");
    Serial.print(InputIntensity);
    Serial.print(" | Output Intensity: ");
    Serial.println(LaserIntensity);
}

void loop() {
    // Main loop code (if needed)
}
