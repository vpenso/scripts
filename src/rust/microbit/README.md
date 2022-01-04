Rust Embedded for Micro:Bit  
<https://docs.rust-embedded.org/discovery/microbit>  
<https://github.com/rust-embedded/discovery>

### Configuration

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
