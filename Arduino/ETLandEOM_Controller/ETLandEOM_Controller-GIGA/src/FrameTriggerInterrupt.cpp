#include <Arduino.h>
#include "Parameters.h"
#include "VoltageStep.h"
#include "ETLFlagState.h"

void FrameTriggerInterrupt() {
    VoltageStep();
    ETLFlagState();
}