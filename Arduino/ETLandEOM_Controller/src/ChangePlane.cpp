#include <Arduino.h>
#ifndef ChangePlane_h
#define ChangePlane_h

void ChangePlane(int CurrentImagingPlane, int TotalImagingPlanes,int TTLPulse_ETL, int Delay) {
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

#endif