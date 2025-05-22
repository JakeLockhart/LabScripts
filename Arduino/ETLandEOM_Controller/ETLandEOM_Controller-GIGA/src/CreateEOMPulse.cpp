#include <Arduino.h>
#include "Parameters.h"
#include "VoltageStep.h"

void CreateEOMPulse() {
    if (CurrentImagingPlane == 1) {
        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[VoltageStepIndex]);
        
        delayMicroseconds(PulseWidth);

        analogWrite(TTLPulse_EOM, 0);
    }
    else {
        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[VoltageStepIndex]);
        delayMicroseconds(PulseWidth);
        analogWrite(TTLPulse_EOM, 0);
    }
}