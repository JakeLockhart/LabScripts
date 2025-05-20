# Simulated MScan with an Arduino Board
This project uses an Arduino Due board
MScan sends one pulse per imaging frame to the M302RM amplifier which is subsequently sent to the eletric optic modulator (EOM). The amplitude of these pulses varies based on the slider on MScan's software which controls 'Laser Intensity %'. The changes in signal amplitude and controlling the slider seems to have a negligbile delay (if any at all).
To create the ETL/EOM controller and troubleshoot errors without damaging the resonant two-photon microscope, this project will simulate the slider bar on MScan to create pulses that the ETL/EOM controller can respond to.

## Logic
This system uses analog outputs and analog inputs to control waveform amplitudes. The baseline amplitude can be selected, but a potentiometer can be used to simulate the slider bar.

## Problem
This project operates on a void loop(){} as opposed to an interrupt function. ADC interrupt functions exist, but are more complicated than digital interrupt functions (which have a built-in function = attachInterrupt()). For more sensitive projects where timing is a concern, develop the ADC interrupt function.