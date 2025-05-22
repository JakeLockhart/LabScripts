#ifndef Parameters_h
#define Parameters_h

const int MAX_Planes = 20;

extern int Wavelength;
extern int TotalImagingPlanes;
extern int ImagingPlaneDepths[MAX_Planes];
extern int InputIntensity[MAX_Planes];

extern int NewLine_MScan;
extern int NewFrame_MScan;
extern int TTLPulse_ETL;
extern int TTLPulse_EOM;

extern int PulseWidth;
extern int PulseGap;
extern float ReferenceVoltage;
extern int VoltageStepIndex;
extern int CurrentImagingPlane;
extern volatile int FrameCounter;
extern volatile bool EOMFlag;
extern volatile bool ETLFlag;
extern float LaserIntensity[MAX_Planes];
extern float LaserVoltage[MAX_Planes];
extern float LaserVoltage_Bits[MAX_Planes];

#endif