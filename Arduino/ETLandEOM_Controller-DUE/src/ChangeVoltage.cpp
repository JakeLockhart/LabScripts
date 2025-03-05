#include <Arduino.h>
#include "ChangePlane.h"
#include "Parameters.h"

int i = 0;
void ChangeVoltage() {
    if (CurrentImagingPlane == 1) {
        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[i]);
        delayMicroseconds(Delay);
        analogWrite(TTLPulse_EOM, 0);
        CurrentImagingPlane = TotalImagingPlanes;
        if (i == TotalImagingPlanes) {
            i = 0;
        }
        else {
            i++;
        }
    }
    else {
        CurrentImagingPlane--;
    }
}