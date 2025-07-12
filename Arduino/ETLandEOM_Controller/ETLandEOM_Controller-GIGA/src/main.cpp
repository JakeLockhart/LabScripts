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
#include "FrameTriggerInterrupt.h"
#include "LineTriggerInterrupt.h"
#include "CreatePulses.h"


void setup() {
    // Preprocess voltage and power reference tables based on user input parameters
        DataProcessing();

    // Setup serial monitor, pin modes, and analog resolution
        GeneralSetup();

    // Serial output
        MonitorSerialOutput();

    // Interrupt
        attachInterrupt(digitalPinToInterrupt(NewFrame_MScan), FrameTriggerInterrupt, RISING);
        attachInterrupt(digitalPinToInterrupt(NewLine_MScan), LineTriggerInterrupt, RISING);
}

void loop() {
    if (EOMFlag || ETLFlag){
        if (EOMFlag){
            CreateEOMPulse();
            EOMFlag = false;
            ETLFlag = false;
        }
        if (ETLFlag){
            CreatePulses();
            //CreateETLPulse(); Originally just CreateETLPulse()
            //CreateEOMPulse(); This delays the EOM pulse creation to after the ETL pulse is returned to LOW. (De-syncs first line)
            EOMFlag = false;
            ETLFlag = false;
        }
    }
}