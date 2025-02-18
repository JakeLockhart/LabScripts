#include <Arduino.h>
#include "ChangePower.h"
#include "Parameters.h"

extern float EOM_LaserIntensity[MAX_Planes];
void ChangePower() {
    if (CurrentImagingPlane == 1) {
        analogWrite(TTLPulse_EOM, EOM_LaserIntensity[CurrentImagingPlane]);
        delayMicroseconds(Delay);
        analogWrite(TTLPulse_EOM, 0);
        CurrentImagingPlane = TotalImagingPlanes;        
    }
    else {
        CurrentImagingPlane--;
    }
}