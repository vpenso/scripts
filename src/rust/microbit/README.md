Rust Embedded Micro:Bit  
<https://docs.rust-embedded.org/discovery/microbit>

Install additional [components for embedded development][01] and configure the host:

```bash
sudo dnf install -y pkg-config libusb-devel systemd-devel gdb minicom
rustup component add llvm-tools-preview
cargo install cargo-binutils cargo-embed
# use an USB devices like the micro:bit without root privilege
cat <<EOF | sudo tee /etc/udev/rules.d/99-microbit.rules
# CMSIS-DAP for microbit
SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
EOF
sudo udevadm control --reload-rules
```

Verify the [build tool chain][02] for **Micro:Bit v2**:

```bash
# get the example code
>>> git clone https://github.com/rust-embedded/discovery.git
>>> rustup target add thumbv7em-none-eabihf
>>> cd discovery/microbit/src/03-setup
# make sure to select the right chip
>>> grep ^chip Embed.toml
chip = "nrf52833_xxAA" # uncomment this line for micro:bit V2
# build and flash the device
>>> cargo embed --target thumbv7em-none-eabihf
```

Source Code, GitHub  
<https://github.com/rust-embedded/discovery>

Nordic nRF52833, Nordic Semiconductor  
<https://www.nordicsemi.com/products/nrf52833>  
<https://infocenter.nordicsemi.com/pdf/nRF52833_PS_v1.5.pdf>

### Terminology

* Peripheral Access Crate (PAC) direct interface to the peripherals of the chip
  - <https://docs.rs/nrf52833-pac>
  - <https://github.com/nrf-rs/nrf-pacs>
* Hardware Abstraction Layer (HAL)  build up on top of the chip's PAC and
  provide an abstraction that is actually usable
  - <https://docs.rs/nrf52833-hal>
  - <https://github.com/nrf-rs/nrf-hal>
* Board Support Crate (BSP) abstract a whole board (such as the micro:bit)
  - <https://docs.rs/microbit>
  - <https://github.com/nrf-rs/microbit>
* Embedded HAL, core of the ecosystem
  - Provides traits for common peripherals (GPIO, Timers, UART, etc.)
  - HALs implement `embedded-hal` traits usually by using PACs
  - Drivers use traits to talk with external devices

An Overview of the Embedded Rust Ecosystem, Oxidize 2020  
<https://www.youtube.com/watch?v=vLYit_HHPaY>

[01]: https://docs.rust-embedded.org/discovery/microbit/03-setup/index.html
[02]: https://docs.rust-embedded.org/discovery/microbit/03-setup/verify.html
