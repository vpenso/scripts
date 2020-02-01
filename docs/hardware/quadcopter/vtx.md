
* **FPV** (First Person View) Video piloting by live streaming to video 

# **VTX** (Video Transmitter)

* _Reads the video signal from the flight camera and transmits the stream down to ground_
* **Transmission Power**, aka power output: 25mW (used for indoor flight), 200mW, 600mW
  - Power radiated through the transmitter
  - More power may increase range, with the cost of increased noise on sidebands
  - Regulation in Europe forbids transmission above 25mW
* _FPV transmitter/receiver require to work on compatible frequenzy/channel_
* **5.8Ghz** is the most common used transmission frequency for the video signal
* **Band**
  - **F** FS/IRC
  - **E** Lumenier/DJI
  - **A** Boscam A
  - **R** Raceband
* **Channels**: 32-40 channels
  - Channels incrementally aligned with a band
  - **Channel chart** lists supported channels of a VTX
  - Multiple channels allow parallel signals on a single frequency
  - **Raceband** optimum frequency distribution for up to 6 pilots
* **Channel Switching Mechanism**
  - DIP switches (require screwdriver, and channel chart)
  - Digital switch with button (auto cycle channels) [often band at racing events]
  - Programmable with infrared remote (often proprietary receiver)
* **Voltage Tolerance**
  - _Check if the VTX supports the voltage of the battery_
  - **Voltage Regulator** (on the PDB) allows to provide lower voltage for the VTX if required
  - **LC Filter** filters noise from the electricity (from the ESCs) to ensures smooth power supply for best FPV performance
* VTX ground should not touch a carbon frame
  - May overheat due to resistance
  - Back feed noise
* **OSD** On Screen Display
  - Overlays flight information onto the video stream
  - Enables the pilot to monitor the vehicle in real-time
  - Flight data monitored: battery voltage, motor current, altitude, etc.
  - **RSSI** indicator for radio signal strength

# Antennas

* Tuned to specific frequency, typically 5.8GHz
* Antenna **Polarization**
  - **Linear** & **Circular**, different radiation/emission patter (single plane vs. circular plane (corkscrew))
  - Linear provides extra range, antennas need to be aligned to maximise the radiation pattern overlap (to prevent signal loss)
  - Circular, better signal reception, reject multi-path signals
* Directional & Omnidirectional Polarization
  - Directional antennas increase range but reduce coverage (long narrow beam)
  - Omnidirectional antennas increase coverage but reduce range (short wide beam)
* **Types of Antennas**
  - Duck/Dipole: Linear, omnidirectional
  - Skew Planar: Circular, omnidirectional (4 lobs)
  - Cloverleaf: Circular, omnidirectional (3 lobe)
  - Array: Circular, omnidirectional
  - Helical: Circular, directional
  - Patch: Can be both circular or linear, directional
  - Crosshair: Circular, directional
  - Yagi: Linear, directional
* **Antenna Connector** SMA (most popular), RP-SMA
* **Gain** 
  - Alters the shape of the radiation pattern to gain extra range
  - Measure of power in **decibel** (dB)
* **Diversity Receivers** (dual receiver systems)
  - Combine multiple antennas and receivers on the ground
  - Monitor and dynamically select the receiver with the strongest signal

# Camera

* Most FPV cameras use analogue video, resolution **TVL** (TV lines)
* Video Standards
  - **PAL** 720x567@25fps
  - **NTSC** 720x480@30fps
* **CMOS** image sensor
  - Rolling shutter (capture image pixel by pixel), vibrations may case negative effect on video stream
  - Usually light and use less power CCD
* **CCD** image sensor
  - More expensive compared to CMOS sensors
  - Global shutter (entire image captured at once)
  - Large dynamic range to perform better in bright/dark conditions
* Latency
  -  Delay introduced during processing of the image data
  - Typical latency 140ms
* **Field of View**
  - Angel captured by the lens, focal length in millimeter
  - Higher field of you allow to see more around (may distort boarder, or curve horizon)

