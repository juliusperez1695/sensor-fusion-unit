# Sensor Fusion Embedded Solution Prototype
## Description
Subsea vehicles such as ROVs and AUVs are equipped with various sensors, primarily for determining the vehicle's precise orientation and heading within the operating space or for mapping out the surrounding environment.  The issue is each sensor likely operates and transmits data at unique speeds, and if each reading is processed sequentially such as in a single-threaded C program, it is then likely that each reading will be associated with the incorrect moment in time.  As a result, the reported orientation or produced image will be considerably distorted and probably useless for the end user.  

To address this time discrepancy between measurements, a system-on-chip (SoC) solution will be explored where digital logic will incorporate hardware interrupts and timestamping to determine the precise arrival time of sensor data, and the processing system will be used for multithreaded tasking, software interrupts and fusion algorithm implementation.  Initial prototyping and proof of concept will be executed with the Zybo Z7-10 (or 20, depending on availability) which is equipped with the Xilinx Zynq-7000 SoC.  Developing on this chip allows for Free Tier use of Xilinx's Vivado and Vitis for both hardware and embedded software design while providing the capability to acquire and process data from at least a few sensors via SPI/UART/etc.  

## Required Equipment/Software
* Xilinx Zybo Z7-10/20 Development Board (Zync-7000 SoC)
* Micro USB Cable
* Sensors of choice (ex. Inertial Measurement Unit and simulated DVL strings for vehicle orientation)
* Python for generating test inputs

## Things to Consider
* Can hardware design be simply expanded to handle more sensors?
* Can software design handle fusion for both orientation data and environmental mapping?

## System/Module Design
[System Overview]

[Timestamping Module - Digital Logic Block]

[Sensor Fusion - Software Block]

## Design Verification
[Test Cases]
