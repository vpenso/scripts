```bash
├── build.rs
├── .cargo
│   └── config          # Configure build and linking 
├── Cargo.toml          # Project metadata and dependencies
├── Embed.toml          # Cargo embedded configuration
├── memory.x            # Specify the memory layout of the target device
└── src
    └── main.rs
```

Template for building applications for ARM Cortex-M microcontroller  
<https://docs.rust-embedded.org/cortex-m-quickstart/cortex_m_quickstart>

Cargo subcommand to work with embedded targets  
<https://docs.rs/crate/cargo-embed>
