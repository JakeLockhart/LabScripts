#include "OscilloscopeVoltage.h"

// Oscilloscope Voltage Readings
    // Analog voltage readings sent to EOM amplifer in response to changing laser intensity on MScan
    // Laser Intensity | Base Noise | Peak Noise | Voltage Range (Base-Peak) | Voltage Gap (Base-Peak)
    OScope data_OScope[] = {
        {0,     {104,   -1,     -1,     60.8}},
        {10,    {104,   76,     34,     200 }},
        {20,    {104,   88,     120,    296 }},
        {30,    {104,   100,    204,    392 }},
        {40,    {104,   92,     288,    490 }},
        {50,    {104,   96,     384,    592 }},
        {60,    {104,   100,    464,    688 }},
        {70,    {104,   120,    560,    792 }},
        {80,    {104,   120,    620,    880 }},
        {90,    {104,   120,    720,    976 }},
        {100,   {104,   120,    800,    1090}},
};

const int data_OScope_size = sizeof(data_OScope) / sizeof(data_OScope[0]);