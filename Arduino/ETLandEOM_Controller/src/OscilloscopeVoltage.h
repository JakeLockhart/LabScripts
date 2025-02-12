#ifndef OscilloscopeVoltage_h
#define OscilloscopeVoltage_h
//  This contains voltage readings that are sent to the EOM amplifier in 
//      response to changing laser intensity in MScan

// Define table structure
struct OScope {
    float InputIntensity;
    float OutputVoltage[4];
};

// Define table array
// Input Laser Intensity [%] | Noise Floor | Noise Peak | Voltage Gap (Between Base & Peak) | Voltage Range (Base - Peak) [mV]
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

#endif