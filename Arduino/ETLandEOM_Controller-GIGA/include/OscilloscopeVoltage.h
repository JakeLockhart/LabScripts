#ifndef OscilloscopeVoltage_h
#define OscilloscopeVoltage_h

struct OScope_LV {
    float MScanInput;
    float LowVoltage[4];
};
struct OScope_HV {
    float MScanInput;
    float HighVoltage[4];
};

extern OScope_LV data_OScopeLowVoltage[];
extern OScope_HV data_OScopeHighVoltage[];
extern const int data_OScope_size;

#endif