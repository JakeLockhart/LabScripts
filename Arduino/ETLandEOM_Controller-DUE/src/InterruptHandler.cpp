#include <Arduino.h>
#include "InterruptHandler.h"
#include "ChangePV.h"

void InterruptHandler() {
    ChangePV();
}