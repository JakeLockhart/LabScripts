# Oscilloscope Scripts
The scripts in this folder are created to analyze the oscilloscope data obtained from the ETL/EOM-DUE circuit. Each script was designed for a specific section of the design process. Instead of trying to make a large script with user-prompts and UI, I divided the scripts into individual segments. The purpose of each segment is described below:

## OscopeMScanAnalysis.m
This script was designed to take recordings of waveforms that are sent directly from the MScan software. While the laser is 'on,' MScan sends signals to a 302RM ConOptics Amplifier. The waveform of these signals (specifically the magnitude) chnages as the laser intensity [%] increases. This script was designed to analyze multiple .CSV files within a single folder that come from the oscilloscope.
- **Inputs**: A single folder of .CSV files. No special naming convention needed, raw title from oscilloscope is preferable. Record one waveform to one .CSV and save to a folder. When run, the script will ask for this folder only.
- **Outputs**: Several graphs to describe the waveform and specifically its amplitidue. One tiledlayout() of histograms for each waveform to determine Low Voltage and High Voltage. A final graph that shows a concatenated histogram, aligned single peaks for each waveform, and a graph showing the ~linear voltage increase with respect to laser inpt intensity. Finally, a .txt file is created for the Low and High Voltages.

## OscopeTxtConcatentation.m
This script was a sanity check to confirm that multiple oscilloscope readings for the same range of laser input intensities produced a linear relationship. The goal was to concatenate the .txt results for multiple oscilloscope recording sessions into a single graph.
- **Inputs**: A single folder of the .txt files containing the Low Voltage and High Voltage.
- **Outputs**: Graphs depicting the linear relationship between voltage and laser input intensity.

## OscopeCircuitAnalysis.m
This script is designed to validate the values that the Arduino Due is outputing in response to a simulated MScan input signal.