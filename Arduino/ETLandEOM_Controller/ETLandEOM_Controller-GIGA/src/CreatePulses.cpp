#include <Arduino.h>
#include "Parameters.h"
#include "VoltageStep.h"
#include "CreateEOMPulse.h"

void CreatePulses(){
    digitalWrite(TTLPulse_ETL, HIGH);
    CreateEOMPulse();
    digitalWrite(TTLPulse_ETL, LOW);
}
