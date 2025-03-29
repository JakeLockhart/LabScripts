# ETL and EOM Controller
This project uses an Arduino Due board
The Due is used to send two outputs, one TTL pulse being sent to the ETL and one analog pulse being sent to an amplifyier and then the EOM.

## Logic 
The scripts for this project work correctly but do not behave correctly based on hardware problems, not software problems. The Due has a DAC range [0.5mV : 2.75V]. Reference values collected from MScan on an oscilloscope show that required range with a lower bound [0mV : ~ 1.5V].
However, scripting logic works correctly and can be used for another board with the correct hardware. Essentially, these scripts accept incoming pulses from a simulated MScan board (Arduino Uno in this case) and output two signals based on hard-coded reference tables. Interpolation is used on the reference tables for a smooth transition between input laser intensities. An attachInterrupt() function is used to call and interrupt service routine (ISR) to change the amplitude of the analog output signal (ChangePV.cpp) with respect to new input pulses.

## Problem
Arduino DUE board has a DAC range of 0.5mV : 2.75V, which is not appropriate for the ETL and EOM controller. Lower output values must be available with preferebaly a higher resolution and timing, but not required.