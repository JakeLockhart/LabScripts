#include <Arduino.h>
#include "ChangePlane.h"
#include "Parameters.h"

void ChangePlane() {
    if (CurrentImagingPlane == 1) {
        digitalWrite(TTLPulse_ETL, HIGH);
        delayMicroseconds(Delay);
        digitalWrite(TTLPulse_ETL, LOW);
        CurrentImagingPlane = TotalImagingPlanes;
    }
    else {
        CurrentImagingPlane--;
    }
}