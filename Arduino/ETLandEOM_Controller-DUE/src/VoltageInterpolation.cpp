#include <Arduino.h>
#include "Wavelengths.h"
#include "OscilloscopeVoltage.h"

// Create linear interpolation function
float LinearInterpolation(float x, float x0, float y0, float x1, float y1) {
    float t = (x - x0) / (x1 - x0);
    return (1 - t) * y0 + t * y1;
}

// Create voltage interpolation function
void VoltageInterpolation(int Wavelength, int* MScanInput, int TotalPlanes, float* OutputVoltage) {
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
                OutputVoltage[i] = NAN;
            }
            return;
        }
    // Interpolate for each element of the High Voltage Array
        for (int i; i < TotalPlanes; i++) {
            int Intensity = MScanInput[i];
            // Is Intensity within VoltageResult bounds [0%, 100%]
                if (Intensity < data_OScopeHighVoltage[0].MScanInput || Intensity > data_OScopeHighVoltage[data_OScope_size - 1].MScanInput) {
                    Serial.print("Error: Input intensity ");
                    Serial.print(Intensity);
                    Serial.println(" not within PowerResults bounds [0%, 100%]. Assigning NaN.");
                    OutputVoltage[i] = NAN; 
                    continue; 
                }
            // Find neighboring points for interpolation
                
        }

}