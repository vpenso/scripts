```bash
├── build.rs
├── .cargo
│   └── config
├── Cargo.toml
├── Embed.toml
├── memory.x            # specify the memory layout of the target device
└── src
    └── main.rs
```

Build for ARM Cortex-M4F (with FPU support)

```bash
cargo embed --target thumbv7em-none-eabihf
```

Rust on BBC micro:bit - starting with a blinky  
<https://flames-of-code.netlify.app/blog/rust-microbit/>

Template for building applications for ARM Cortex-M microcontroller  
<https://docs.rust-embedded.org/cortex-m-quickstart/cortex_m_quickstart>
