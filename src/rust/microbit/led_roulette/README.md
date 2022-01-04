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

Flash with `cargo embed`, move a program into the microcontroller's (persistent) 
memory (configured in `Embed.toml`).

The option `default.gdb.enabled = true` open a so-called "GDB stub" after
flashing, this is a server that our GDB can connect to and send commands like
"set a breakpoint at address X" to. The server can then decide on its own how
to handle this command. In the case of the `cargo-embed` GDB stub it will forward
the command to the debugging probe on the board via USB which then does the job
of actually talking to the MCU for us.

```bash
# open the binary in gdb like this
gdb target/thumbv7em-none-eabihf/debug/led_roulette
# connect to the GDB stub, runs on localhost:1337 per default
(gdb) target remote :1337
```
