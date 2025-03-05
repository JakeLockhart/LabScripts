#include <Arduino.h>
#include "InterruptHandler.h"
#include "ChangePlane.h"
#include "ChangeVoltage.h"

void InterruptHandler() {
    ChangePlane();
    ChangeVoltage();
}