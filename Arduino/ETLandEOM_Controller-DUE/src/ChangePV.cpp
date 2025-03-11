#include <Arduino.h>
#include "Parameters.h"

int i = 0;
void ChangePV() {
    if (CurrentImagingPlane == 1) {
        digitalWrite(TTLPulse_ETL, HIGH);
        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[i]);
        
        delayMicroseconds(Delay);

        digitalWrite(TTLPulse_ETL, LOW);
        analogWrite(TTLPulse_EOM, 0);
        CurrentImagingPlane = TotalImagingPlanes;

            if (i == TotalImagingPlanes-1) {
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