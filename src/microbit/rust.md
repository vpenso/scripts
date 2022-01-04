Install additional [components for embedded development][01]:

```bash
sudo dnf install -y pkg-config libusb-devel systemd-devel gdb minicom
rustup component add llvm-tools-preview
cargo install cargo-binutils cargo-embed
```

Use an USB devices like the micro:bit without root privilege:

```bash
cat <<EOF | sudo tee /etc/udev/rules.d/99-microbit.rules
# CMSIS-DAP for microbit
SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
EOF
sudo udevadm control --reload-rules
```

Verify the [build tool chain][02]:

```bash
# get the example code
>>> git clone https://github.com/rust-embedded/discovery.git
# for micro:bit v2
>>> rustup target add thumbv7em-none-eabihf
>>> cd discovery/microbit/src/03-setup
# make sure to select the right chip
>>> grep ^chip Embed.toml
chip = "nrf52833_xxAA" # uncomment this line for micro:bit V2
# build and flash the device
>>> cargo embed --target thumbv7em-none-eabihf
```

### References

Rust Embedded Micro:Bit  
<https://docs.rust-embedded.org/discovery/microbit>

Source Code, GitHub  
<https://github.com/rust-embedded/discovery>

[01]: https://docs.rust-embedded.org/discovery/microbit/03-setup/index.html
[02]: https://docs.rust-embedded.org/discovery/microbit/03-setup/verify.html
