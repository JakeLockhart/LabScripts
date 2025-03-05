#include <Arduino.h>
#include "Wavelengths.h"
#include "LinearInterpolation.h"
#include "PowerResults.h"

// Create power interpolation function
void PowerInterpolation(int Wavelength, int* InputPower, int TotalPlanes, float* OutputPower) {
    // Determine the table column based on Wavelength
        int TotalWavelengths = sizeof(data_WavelengthList[0].Wavelengths) / sizeof(data_WavelengthList[0].Wavelengths[0]);
        int ColumnIndex = -1;
        for (int i = 0; i < data_WavelengthList_size; i++) {
            for (int j = 0; j < TotalWavelengths; j++) {
                if (data_WavelengthList[i].Wavelengths[j] == Wavelength) {
                    ColumnIndex = j;
                    break;
                }
            }
            if (ColumnIndex != -1) break;
        }
        if (ColumnIndex == -1) {
            Serial.println("Error: No matching Wavelength in PowerResults");
            for (int i = 0; i < TotalWavelengths; i++) {
                OutputPower[i] = NAN;
            }
            return;
        }
    // Interpolate for each element of the InputIntensity array
        for (int i = 0; i < TotalPlanes; i++) {
            int Intensity = InputPower[i];
            // Is Intensity within PowerResult bounds [0%, 100%]
            if (Intensity < data_PowerResults[0].InputIntensity || Intensity > data_PowerResults[data_PowerResults_size - 1].InputIntensity) {
                Serial.print("Error: Input intensity ");
                Serial.print(Intensity);
                Serial.println(" not within PowerResults bounds [0%, 100%]. Assigning NaN.");
                OutputPower[i] = NAN; 
                continue; 
            }
            // Find neighboring points for interpolation
                for (int j = 0; j < data_PowerResults_size - 1; j++) {
                    if (data_PowerResults[j].InputIntensity <= Intensity && data_PowerResults[j+1].InputIntensity >= Intensity) {
                        OutputPower[i] = LinearInterpolation(
                            Intensity,
                            data_PowerResults[j].InputIntensity, data_PowerResults[j].LaserIntensity[ColumnIndex],
                            data_PowerResults[j+1].InputIntensity, data_PowerResults[j+1].LaserIntensity[ColumnIndex]
                        );
                        break;
                    }
                }
        }
}