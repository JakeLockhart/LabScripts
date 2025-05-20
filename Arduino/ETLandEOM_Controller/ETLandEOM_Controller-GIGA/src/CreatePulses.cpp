#include <Arduino.h>
#include "Parameters.h"

// Original - ETL pulse causes new voltage step
//int i = 0;
//void CreatePulses() {
//    if (CurrentImagingPlane == 1) {
//        digitalWrite(TTLPulse_ETL, HIGH);
//        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[i]);
//        
//        delayMicroseconds(PulseWidth);
//
//        digitalWrite(TTLPulse_ETL, LOW);
//        analogWrite(TTLPulse_EOM, 0);
//        CurrentImagingPlane = TotalImagingPlanes;
//
//            if (i == TotalImagingPlanes-1) {
//                i = 0;
//            }
//            else {
//                i++;
//            }
//        }
//    else {
//        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[i]);
//        delayMicroseconds(PulseWidth);
//        analogWrite(TTLPulse_EOM, 0);
//        CurrentImagingPlane--;
//    }
//}

// New - ETL pulse resets voltage step to i = 0
int i = 0;
void CreatePulses() {
    if (CurrentImagingPlane == 1) {
        digitalWrite(TTLPulse_ETL, HIGH);
        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[i]);
        
        delayMicroseconds(PulseWidth);

        digitalWrite(TTLPulse_ETL, LOW);
        analogWrite(TTLPulse_EOM, 0);
        CurrentImagingPlane = TotalImagingPlanes;
        i = 0;
        }
    else {
        analogWrite(TTLPulse_EOM, LaserVoltage_Bits[i]);
        delayMicroseconds(PulseWidth);
        analogWrite(TTLPulse_EOM, 0);
        i++;
        CurrentImagingPlane--;
    }
}