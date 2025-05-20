#ifndef Parameters_h
#define Parameters_h

const int MAX_Planes = 20;

extern int Wavelength;
extern int TotalImagingPlanes;
extern int ImagingPlaneDepths[MAX_Planes];
extern int InputIntensity[MAX_Planes];

extern int NewFrame_MScan;
extern int TTLPulse_ETL;
extern int TTLPulse_EOM;

extern int Delay;
extern float ReferenceVoltage;
extern int CurrentImagingPlane;
extern float LaserIntensity[MAX_Planes];
extern float LaserVoltage[MAX_Planes];
extern float LaserVoltage_Bits[MAX_Planes];

#endif