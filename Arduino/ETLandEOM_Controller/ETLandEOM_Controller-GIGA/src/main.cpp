#include <Arduino.h>
#include "Parameters.h"
#include "PowerInterpolation.h"
#include "VoltageInterpolation.h"
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "PowerResults.h"
#include "OscilloscopeVoltage.h"
#include "CreateEOMPulse.h"
#include "CreateETLPulse.h"
#include "MonitorSerialOutput.h"
#include "EOMFlagState.h"
#include "GeneralSetup.h"
#include "DataProcessing.h"
#include "VoltageStep.h"

void setup() {
    // Preprocess voltage and power reference tables based on user input parameters
        DataProcessing();

    // Setup serial monitor, pin modes, and analog resolution
        GeneralSetup();

    // Serial output
        MonitorSerialOutput();

    // Interrupt
        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), VoltageStep, RISING);
        attachInterrupt(digitalPinToInterrupt(NewLine_MScan), EOMFlagState, RISING);
}

void loop() {
    if (EOMFlag || ETLFlag){
        if (EOMFlag){
            CreateEOMPulse();
            EOMFlag = false;
        }
        if (ETLFlag){
            CreateETLPulse();
            ETLFlag = false;
        }
    }
}