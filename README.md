
# FPGA Project: ECG Signal Encryption with ASCON


## Overview

This project implements a secure encryption system for ECG signals using an FPGA.
ECG frames are read from a CSV file, transmitted via UART to an FPGA board where they are encrypted with the **ASCON** algorithm (lightweight and secure). The encrypted data is then sent back to a Python script for decryption and visualization.

## Architecture

* **FPGA (Pynq-Z2)**: ASCON algorithm implementation with control FSM
* **UART FSM**: manages serial communication
* **Python**: signal acquisition, decryption, and ECG visualization

   <img width="1000" height="800" alt="image" src="https://github.com/user-attachments/assets/a5998826-4027-465f-b45b-c330d9241c7a" />


## Main Steps

1. Program the FPGA with the provided bitstream (`FPGA_ASCON128/`).
2. Connect the UART module to the PMOD A port of the Pynq-Z2 board and link it to the PC via USB.
3. Run the script `communication_fpga.py` (in the `communication_python/` directory) to access the user interface.

## Features

* Read ECG signals from a CSV file
* Transmit signals to the FPGA for encryption
* Receive and decrypt data via Python
* Visualize and compare signals before and after encryption

## Requirements

* FPGA board **Pynq-Z2**
* **Vivado** software for FPGA programming
* Python 3 with the following libraries: `pyserial`, `matplotlib`, `pandas`
