
# MicroBit

Single Board Computer (SBC) [mbhw]

* Nordic **nRF52** Application Processor connected to...
  - Arm **Cortex-M4** 64MHz 32 bit processor with FPU
  - 512KB Flash ROM, 128KB RAM
* ...an USB interface processor NXP KL27Z
  - Used for flashing new code
  - Sending and receiving serial data back and forth to your main computer (host)
  - SWD software debug interface

Rust software stack for embedded programming is Embedded HAL

* Provides traits for common peripherals (GPIO, Timers, UART, etc.)
* HALs implement `embedded-hal` traits usually by using PACs
* Drivers use traits to talk with external devices

As specific implementation for the nRF52 application processor

* Hardware Abstraction Layer (HAL)  build up on top of the chip's PAC and
  provide an abstraction that is actually usable
  - <https://docs.rs/nrf52833-hal>
  - <https://github.com/nrf-rs/nrf-hal>
* Peripheral Access Crate (PAC) direct interface to the peripherals of the chip
  - <https://docs.rs/nrf52833-pac>
  - <https://github.com/nrf-rs/nrf-pacs>

The MicroBit board is implemented in a **Board Support Crate** (BSP)

* <https://docs.rs/microbit>
* <https://github.com/nrf-rs/microbit>


## Prerequisites

Install additional components for embedded development and configure the host:

```bash
sudo dnf install -y pkg-config libusb-devel systemd-devel gdb minicom
rustup component add llvm-tools-preview
rustup target add thumbv7em-none-eabihf
cargo install cargo-binutils cargo-embed
# use an USB devices like the micro:bit without root privilege
cat <<EOF | sudo tee /etc/udev/rules.d/99-microbit.rules
# CMSIS-DAP for microbit
SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
EOF
sudo udevadm control --reload-rules
```

Verify that development environment is work using the [hello_world](hello_world) example.


## Cargo Embed

[`cargo-embed`][embed] is the big brother of `cargo-flash`


[embed]: <https://docs.rs/crate/cargo-embed>

* Flash a target just like cargo-flash...
* ...can open an RTT terminal as well as a GDB server.
  - RRT (real time transfers) between host and device
  - Read/write ringbuffers accessible by target and the debug host
  - Uses [`rrt_target`][rrt] implementation 

[rrt]: https://docs.rs/rtt-target

Configured via a `Embed.toml` in the project root cf. [cargo-embed/src/config/default.toml](https://github.com/probe-rs/cargo-embed/blob/master/src/config/default.toml)


```toml
[default.probe]
# The protocol to be used for communicating with the target.
protocol = "Swd"

[default.general]
# The chip name of the chip to be debugged
chip = "nrf52833_xxAA" # micro:bit V2

[default.rtt]
# Whether or not an RTTUI should be opened after flashing.
enabled = true

[default.gdb]
# Whether or not a GDB server should be opened after flashing.
enabled = false
```

[blink/](blink/) is a basic example for using RTT.


# References

Rust Embedded for Micro:Bit  
<https://docs.rust-embedded.org/discovery/microbit>  
<https://github.com/rust-embedded/discovery>

MicroRust  
<https://droogmic.github.io/microrust/>

[mbhw] MicroBit Hardware Overview  
<https://tech.microbit.org/hardware/>

An Overview of the Embedded Rust Ecosystem, Oxidize 2020  
<https://www.youtube.com/watch?v=vLYit_HHPaY>

Awesome Embedded Rust, GitHub  
<https://github.com/rust-embedded/awesome-embedded-rust>