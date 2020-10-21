# Strings

All strings in Rust are **UTF-8 encoded**.

```bash
fn main() {
    // string literal initalizing a `&str` slice
    let ss = "a";
    // create a `String` from a string literal
    let st = "b".to_string();
    // equivalent to
    let sf = String::from("c");
    println!("{} {} {}", ss, st, sf);
}
```
```
a b c
```

The **`&str` slice** is provided by the Rust Core:

* Created using **string literals** (stored in the program’s binary)
* May reference a range of UTF-8 text “owned” by someone else
* Preallocated text that is stored in read-only memory as part of the executable

The **`String` type** is provided by the Rust’s standard library:

* `String` is a wrapper over a `Vec<u8>`
* Stores an object with a pointer on the stack, data is stored in a
  heap-allocated buffer; resizes its buffer when needed
* **Does not support indexing**, since index into the string’s bytes will not
  always correlate to a valid Unicode scalar value.
* Strings have three representations: as bytes, scalar values, and grapheme
  clusters
* Use ranges to create string slices with caution, because doing so can crash
  your program.

> It’s safe to say that, if the API we’re building doesn’t need to own or mutate
> the text it’s working with, it should take a `&str` instead of a `String`

Loop over characters in `String`:

```rust
fn main() {
    let s = "abcde";
    // iterate over a string
    for c in s.chars() {
        println!("{}", c);
    }
}
```

## Append

Append strings by using push-methods of `String`:

```rust
fn main() {
    let mut s = "a".to_string();
    // append a single character
    s.push('b');
    // append an `str` slice
    s.push_str("cde");
    // ownership of slice `t` not moved to `s`
    let t = "f";
    s.push_str(t);
    println!("{} {}", s, t);
}
```
```
abcdef f
```
