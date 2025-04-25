#include <Arduino.h>
#include "Parameters.h"
#include "PowerInterpolation.h"
#include "VoltageInterpolation.h"
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "PowerResults.h"
#include "OscilloscopeVoltage.h"
#include "CreatePulses.h"
#include "MonitorSerialOutput.h"
#include "FlagState.h"
#include "GeneralSetup.h"
#include "DataProcessing.h"

void setup() {
    // Preprocess voltage and power reference tables based on user input parameters
        DataProcessing();

    // Setup serial monitor, pin modes, and analog resolution
        GeneralSetup();

    // Serial output
        MonitorSerialOutput();

    // Interrupt
        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), FlagState, FALLING);
}

void loop() {
    if (Flag){
        //delayMicroseconds(PulseGap);
        CreatePulses();
        Flag = false;
    }
}

