# Cargo

`cargo` is a package manager and build tool for the Rust language:

* Automatically fetches and builds your package’s dependencies
* `Cargo.toml` **manifest**,  metadata & various bits of package information
  - [Specifying Dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)
  - `Cargo.lock` exact information on revision of all dependencies
* [Package Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html)

```bash
cargo new $name            # new package for a binary program
cargo build                # compile to target/debug/ directory
cargo run                  # compile and execute 
cargo build --release      # compile with optimizations to target/release/
cargo update               # update dependencies
cargo test                 # run all tests
```

### References

The Cargo Book  
<https://doc.rust-lang.org/cargo/>

Rust community's central package registry  
<https://crates.io/>
