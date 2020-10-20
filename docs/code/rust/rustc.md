
`rustc` is the compiler for the Rust programming language

```bash
cat > hello_world.rs <<EOF
fn main() {
    println!("Hello World!");
}
EOF
# compile an executable
rustc hello_world.rs
./hello_world
```

### References

The rustc book  
<https://doc.rust-lang.org/stable/rustc/>
