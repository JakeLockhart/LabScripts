#include "Parameters.h"
#include "ETLFlagState.h"

void ETLFlagState(){
    FrameCounter++;
    if(FrameCounter == TotalImagingPlanes) {
        ETLFlag = true;
        FrameCounter = 0;
    }
}