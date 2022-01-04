# Loops

`while` loop begins by evaluating the boolean loop conditional expression, and
returns if the condition becomes `true`:

```rust
fn main() {
    let mut i = 0;
    while i < 10 {
        print!("{} ", i);
        i = i + 1;
    }
}
```
```
0 1 2 3 4 5 6 7 8 9
```

`for in` over a range:

```rust
fn main() {
    for i in 0..5 {
        print!("{} ", i);
    }
}
```
```
0 1 2 3 4
```
