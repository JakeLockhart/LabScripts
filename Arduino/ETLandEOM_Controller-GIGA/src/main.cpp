#include <Arduino.h>
#include "Parameters.h"
#include "PowerInterpolation.h"
#include "VoltageInterpolation.h"
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "PowerResults.h"
#include "OscilloscopeVoltage.h"
#include "InterruptHandler.h"
#include "MonitorSerialOutput.h"

//  This script is designed to control both the ETL and the EOM (Pockel Cell) in response to TTL pulses.
//      Parameters:
//          - Total imaging planes
//          - .txt file of R2P power measurement
//      Goal
//          - Create Gardasoft Code in response to total imaging planes & their respective depths
//          - Use .txt file as a reference to interpolate voltage/laser intensity at a specific imaging depth
//          - Adjust the ETL in response to a TTL pulse
//          - Adjust the EOM in response to a TTL pulse to match new focal depth(s)

void setup() {
    Serial.begin(9600);
    while (!Serial){};
    
    // Pin Setup 
        pinMode(NewFrame_MScan, INPUT);
        pinMode(TTLPulse_ETL, OUTPUT);
        pinMode(TTLPulse_EOM, OUTPUT);

    // Initialization
        analogWriteResolution(12);    
        PowerInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserIntensity);
        VoltageInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserVoltage);
        for (int i = 0; i < TotalImagingPlanes; i++) {
            //LaserVoltage_Bits[i] = (LaserVoltage[i] / ReferenceVoltage) * 4095;
            LaserVoltage_Bits[i] = map(round(1000*LaserVoltage[i]),0,3300,0,4095);
        }
        
    // Intitialization Serial Output
        MonitorSerialOutput();

    // Interrupt
        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), InterruptHandler, RISING);
}

void loop() {
}

