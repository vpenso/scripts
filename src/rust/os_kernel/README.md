
```bash
# install tool to create a bootable disk image [02]
cargo install bootimage
rustup component add llvm-tools-preview
# create a bootable image from the project
cargo bootimage
```

```bash
# start the image with Qemu
qemu-system-x86_64 -drive format=raw,file=target/x86_64-unknown-none/debug/bootimage-os_kernel.bin
# or (cf. `.cargo/config.toml)
cargo run
```

## References

[01] Writing an OS in Rust, Philipp Oppermann  
<https://os.phil-opp.com/>

[02] Rust `bootloader` crate  
<https://crates.io/crates/bootloader>

[03] Rust OSDev  
<https://rust-osdev.com/>
