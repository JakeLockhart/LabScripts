# ETL Controller - Spencer Garborg 
This project uses an Arduino Uno board
A simple and robust code that was used throughout S. Garborg's PhD to control an ETL on the resonant two-photon microscope. This is the original controller for the ETL.

## Logic
Uses an attachInterrupt() function to respond to incoming pulses and output TTL pulses.

## Problem
This code is designed to only control the ETL. It was not designed to control more than two imaging planes (although it can be used to do so).
Very simple.
Not intended to be integrated with larger projects.