#include "Parameters.h"
#include "VoltageStep.h"

void VoltageStep() {
    if (CurrentImagingPlane == 1) {
        CurrentImagingPlane = TotalImagingPlanes;
        VoltageStepIndex = 0;
    }
    else {
        VoltageStepIndex++;
        CurrentImagingPlane--;
    }
}