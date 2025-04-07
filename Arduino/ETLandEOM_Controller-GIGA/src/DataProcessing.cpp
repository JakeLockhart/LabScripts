#include <Arduino.h>
#include <Parameters.h>
#include "PowerInterpolation.h"
#include "VoltageInterpolation.h"

void DataProcessing(){
    PowerInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserIntensity);
    VoltageInterpolation(Wavelength, InputIntensity, TotalImagingPlanes, LaserVoltage);
    for (int i = 0; i < TotalImagingPlanes; i++) {
        //LaserVoltage_Bits[i] = (LaserVoltage[i] / ReferenceVoltage) * 4095;
        LaserVoltage_Bits[i] = map(round(1000*LaserVoltage[i]),0,3300,0,4095);
    }
}

