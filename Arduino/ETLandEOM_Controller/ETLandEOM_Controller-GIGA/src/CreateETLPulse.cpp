#include <Arduino.h>
#include "Parameters.h"
#include "VoltageStep.h"

void CreateETLPulse() {
    digitalWrite(TTLPulse_ETL, HIGH);
    delayMicroseconds(PulseWidth);
    digitalWrite(TTLPulse_ETL, LOW);
}