#include <Arduino.h>
#include "Parameters.h"
#include "EOMFlagState.h"

void LineTriggerInterrupt() {
    EOMFlagState();
}