#include <Arduino.h>
#include "Parameters.h"
#include "GeneralSetup.h"

void GeneralSetup(){
    Serial.begin(9600);
    //    while (!Serial){};
        
    pinMode(NewFrame_MScan, INPUT);
    pinMode(TTLPulse_ETL, OUTPUT);
    pinMode(TTLPulse_EOM, OUTPUT);

    analogWriteResolution(12);
}