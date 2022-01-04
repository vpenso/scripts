Install additional components for embedded development:

```bash
sudo dnf install -y pkg-config libusb-devel systemd-devel minicom
rustup component add llvm-tools-preview
cargo install cargo-binutils cargo-embed
```

```
cat >/etc/udev/rules.d/99-microbit.rules <<EOF
# CMSIS-DAP for microbit
SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
EOF
sudo udevadm control --reload-rules
```


[rsemb] Rust Embedded Micro:Bit  
<https://docs.rust-embedded.org/discovery/microbit>

[01]: https://docs.rust-embedded.org/discovery/microbit/03-setup/index.html
