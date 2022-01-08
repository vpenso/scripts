# Option

Rust does not use exceptions or null values

`Option` represent something or nothing by one of two values...

* ...some value `Some()` (of a given type) or...
* ...no value `None`

<https://doc.rust-lang.org/stable/std/option/>

```rust
pub enum Option<T> {
    None,
    Some(T),
}
```

Try to `unwrap()` some value and return it or `panic`:

```rust
impl<T> Option<T> {
    pub const fn unwrap(self) -> T {
        match self {
            Some(val) => val,
            None => panic!("called `Option::unwrap()` on a `None` value"),
        }
    }
}
```



# Result

`Result`  represents successful or failure by one of two states...

* ...success `Ok()` (of a given type) or...
* ...error `Err()` of type `Error`