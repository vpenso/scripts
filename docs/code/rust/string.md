# Strings

All strings in Rust are **UTF-8 encoded**.

```rust
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
* Stores a pointer on the stack, and data in a heap-allocated buffer
* Automatically resizes its buffer on demand
* Interpretation as bytes, as slice, scalar values, and grapheme clusters
* **No indexing** (bytes do not correlate to a Unicode scalar value)

> It’s safe to say that, if the API we’re building doesn't need to own or mutate
> the text it’s working with, it should take a `&str` instead of a `String`

Rust has this super powerful feature called [`Deref` coercing][deref] which
allows it to turn any passed String reference using the borrow operator:

[deref]: https://doc.rust-lang.org/std/ops/trait.Deref.html#more-on-deref-coercion

```rust
fn puts(s: &str) {
    print!("{}",s)
}
fn main() {
    let s = "ab";             // `&str` slice
    let t = "cd".to_string(); // `String` type
    puts(s);
    puts(&t);                 // pass by reference
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
