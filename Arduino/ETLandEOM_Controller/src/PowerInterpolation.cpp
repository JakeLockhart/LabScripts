#include <Arduino.h>
#include "PowerResults.h"
#include "PowerInterpolation.h"


float PowerInterpolation(int Wavelength, float InputIntensity) {
    Serial.begin(9600);
    int Index = -1;
    for (int i = 0; i < 4; i++) {
        if (data_WavelengthList[0].Wavelengths[i] == Wavelength) {
            Index = i;
            break;
        }
    }
    if (Index == -1) {
        Serial.println("Error: Wavelength not found.");
        return NAN;
    }
    for (int i = 1; i < data_PowerResults_size; i++) {
        if (InputIntensity >= data_PowerResults[i].InputIntensity && InputIntensity <= data_PowerResults[i + 1].InputIntensity) {
            float X1 = data_PowerResults[i].InputIntensity;
            float X2 = data_PowerResults[i + 1].InputIntensity;
            float Y1 = data_PowerResults[i].LaserIntensity[Index];
            float Y2 = data_PowerResults[i + 1].LaserIntensity[Index];
            float Z = Y1 + (InputIntensity - X1) * ((Y2 - Y1) / (X2 - X1));
            return Z;
        }
    }
    Serial.println("Error: Interpolation failed.");
    Serial.end();
    return NAN;
}
