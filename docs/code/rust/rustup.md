# Rustup

`rustup` manages multiple Rust installations in `~/.rustup`

* **toolchain**, single installation of the Rust compiler
* Official release **channels**: stable, beta and nightly
  - Stable channel by default
  - Stable releases are made every 6 weeks (beta is next stable)
* **components** are used to install additional tools for a given toolchain
* **targets** are used to install compilers for other platforms
  - By default the host-platform (architecture and operating system) is used
  - Cross-compilation requires installation of additional targets

Installs `rustc`, `cargo`, `rustup` and other standard tools:

```bash
# installs to ~/.cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source shell environment
source $HOME/.cargo/env
# clean up 
rustup self uninstall
```

Basic usage of a toolchain:

```bash
rustup show                         # show active toolchain
rustup man $command                 # show man-page for a given command
rustup update                       # update to latest version
rustup toolchain help               # toolchain help text
rustup toolchain list               # list installed toolchains
rustup toolchain install $channel   # install from another channel
rustup default $channel             # switch default toolchain
rustup target list                  # list available targets
rustup target add $target           # install an additional target
rustup target remove $target        # install an additional target
rustup component list               # list available components
```


### References

The rustup Book  
<https://rust-lang.github.io/rustup/>
