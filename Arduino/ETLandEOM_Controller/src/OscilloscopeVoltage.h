#ifndef OscilloscopeVoltage_h
#define OscilloscopeVoltage_h

struct OScope {
    float MScanInput;
    float Voltage[4];
};
extern OScope data_OScope[];
extern const int data_OScope_size;

#endif