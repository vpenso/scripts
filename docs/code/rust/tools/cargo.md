# Cargo

`cargo` is a package manager and build tool for the Rust language:

```bash
# create a new project
>>> cargo new hello ; cd hello
     Created binary (application) `hello` package
# basic skeleton
>>> tree
.
├── Cargo.toml
└── src
    └── main.rs
# modify the source code
>>> cat > src/main.rs <<EOF
fn main() {
    println!("Hello World!");
}
EOF
# build an executable
>>> cargo build            
   Compiling hello v0.1.0 (/tmp/hello)
    Finished dev [unoptimized + debuginfo] target(s) in 0.77s
# run the program
>>> cargo run  
    Finished dev [unoptimized + debuginfo] target(s) in 0.00s
     Running `target/debug/hello`
Hello World!

```

* Automatically fetches and builds your package’s dependencies
* `Cargo.toml` **manifest**,  metadata & various bits of package information
  - [Specifying Dependencies](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html)
  - `Cargo.lock` exact information on revision of all dependencies
* [Package Layout](https://doc.rust-lang.org/cargo/guide/project-layout.html)

```bash
$HOME/.cargo/config.toml   # user configuration file [02]
cargo new $name            # new package for a binary program
cargo build                # compile to target/debug/ directory
cargo run                  # compile and execute 
cargo build --release      # compile with optimizations to target/release/
cargo update               # update dependencies
cargo test                 # run all tests
```

### References

[01] The Cargo Book  
<https://doc.rust-lang.org/cargo/>

[02] The Cargo Book - Configuration  
<https://doc.rust-lang.org/cargo/reference/config.html>

[03] Rust community's central package registry  
<https://crates.io/>
