# Option & Result

Rust does not use exceptions or null values.

The `Option<T>` and `Result<T, Err>` types are used to model fallible operations.

_"Wrap" stuff you are not sure about, is this an error or not?_

`Option<T>` represent something or nothing by one of two values...

* ...some value `Some()` (of a given type) or...
* ...no value `None`

<https://doc.rust-lang.org/std/option/>

```rust
pub enum Option<T> {
    None,
    Some(T),
}
```

`Result<T,Err>`  represents successful or failure by one of two states...

* ...success `Ok(T)` (of a given type) or...
* ...error `Err(E)` of type error value

<https://doc.rust-lang.org/std/result/>

```rust
pub enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

# Unwrap and Expect

Helper methods during development...

* `unwrap()` a value `Some(T)` or `Ok(T)` and return it or `panic`
* `unwrap_err()` panic if the value is `Some(T)` or `Ok(T)`
* `unwrap_or(v)` return the value of `Some(T)` or `Ok(T)`, or `v` for `None` or `Err(E)`
* `unwrap_or_default()` returns default type `T` for `None` or `Err(E)`
* `unwrap_or_else(c)`  execute a closure `c` (anonymous function) for `None` or `Err(E)`

`expect(msg)` works very similarly to unwrap with the addition of a custom panic message:

* "expect" a `Result<T,Err>` to be `Ok(T)`
* "expect" an `Option<T>` to be `Some(T)` 

Both of the above are debug tools not meant for production code.

`?` operator can be **used in functions** that have a return type of `Result` or `Option`...

* ...for type that implements `std::ops::Try`
* Unwraps valid values for `Some(T)` or `Ok(T)` or `return` immediately with `None` or `Err(E)`

<https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator>

# Chained transformations

and_then, or_else, map, fold, for_each

## References

Unwrap and Expect in Rust  
<https://jakedawkins.com/2020-04-16-unwrap-expect-rust/>