* RC (Remote Control) Radio **TX** Transmitter (Controller)
  - Controller sticks called **Gimbal**
  - **Mode** controller configuration
  - Mode 1: throttle on the right stick
  - Mode 2 (most common): throttle on the left stick
  - Mode 3/4 rarely used
* All sticks self center with the exception of the throttle axis
* **RX** Receiver build into the vehicle 
* **Frequency**, typically **2.4GHz**, 1.3GHz used for long range
* Frequency Hopping, aka **channel hopping protocol**
  - Software continuously scans for the best frequency
  - Switches channels automatically on radio interference
  - From 2.4000 - 2.4835GHz
* **Binding** is the process of connecting transmitter with a receiver
  - TX/RX pairing requires compatible communication protocols
* **Model** (profiles) memory, save multiple TX/RX pairings
* Training with **Buddy Mode** linking two controllers
* Firmware programs: Cleanflight

# Receiver Protocols

* Communication between radio receiver and the flight controller
* **Taranis** (FrSky)
  - ACCST (Advanced Continuous Channel Shifting Technology)
* **Spektrum** 
  - DSM (Digital Spectrum Modulation)
  - DSM2 uses 2 frequencies for data transmission
  - DSSS (Direct Sequence Spread Spectrum), 2.4GHz modulation, frequency at power-on
  - DSMX up to 60 frequencies for data transmission
  - TEAR assignment for channels 1-4
* **Futaba**
  - FASST (Futaba Advanced Spread Spectrum Technology), supports telemetry
  - FHSS & S-FHSS (Frequency-Hopping Spread Spectrum)
  - AETR assignment for channel 1-4
* OrangeRx (HobbyKing)
* **FlySky** protocol & manufacturer
  - IBUS, bidirectional digital serial protocol
* [Multi-Module](https://github.com/pascallanger/DIY-Multiprotocol-TX-Module) multi protocol transmitter 
  - [nrf24-multipro](https://github.com/goebish/nrf24_multipro)

# Channels

* Determines how many individual actions can be controlled 
* Channels 1-4 control flight
  - **Throttle** motor power up/down
  - **Yaw** rotating right/left (Rudder)
  - **Pitch** lean forward/backward (Elevator)
  - **Roll** lean left/right (Aileron)
* **AUX** (auxiliary) channels for extra switches 
  - Used to change flight modes, trigger functions
  - Recommended at leas **6 channels** for quadcopter
  - **Arm** switch on

# Vendors

## Transmitter

* **FlySky FS-I6** (~50Euro)
  - Frequency: 2.4GHz, 6 channel
  - Protocol: AFHDS 2A 
* **Taranis Q X7**  (>130Euro)
  - Frequency: 2.4Ghz, 16 channels (XJT module)
  - Antenna: 2dbi
  - Protocol: FrSky (X,D series) (externel module)
  - Firmware: OpenTx
  - Telemetry: RSSI
  - Connector: mini USB (firmware updates, simulators, OpenTX companion)
  - RF module: JR type bay for external transmitter modules
  - Aux: 6 switches (2 pots, 4x 3pos)
  - Input: 6~15V
  - Battery: Removable 6xAA battery tray, 2S/3S LiPo compatible (bay dimensions 92x59x17mm)
  - Display: 128x64px backlight LCD
  - Storage: 60 models (additional SD card slot)
* **Taranis X9D Plus** (~250Euro)
* **Multiprotocol Transmitter Module** [01]

## Receivers:

* **Furious Mini RX**
  - Compatible: FrSky Taranis, Taranis Plus, XJT module
  - Size 17x24mm, weight: 2.4g (inc. antenna)
  - SBUS without inversion, HUB telemetry
  - 8 channels, single antenna
  - Voltage: 4-6V

# Ref.

[01] <https://github.com/pascallanger/DIY-Multiprotocol-TX-Module>
