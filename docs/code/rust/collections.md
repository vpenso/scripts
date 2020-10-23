# Collections

Rust's standard collection library:

* Efficient implementations of common data structures.
* Cover most use cases for generic data storage and processing

## Vector

Vectors are **re-sizable arrays**.

* `Vec` is a (pointer, capacity, length) triplet
  - Pointer will never be null, so this type is null-pointer-optimized
  - Memory it points to is on the heap in continuous order of its length
* As low-overhead as possible in the general case
* **Automatic capacity increased** on demand
  - Elements will be reallocated (can be slow)
  - Will never automatically shrink itself

`Vec<T>` in Rust are generic, they have **no default type**.

```rust
fn main() {
    // declare an empty vector with explicit data type
    let mut empty_vector: Vec<i32> = Vec::new();
    println!("{:?}", empty_vector);
}
```

Initialize a vector using the `Vec::new()` method or the `vec!` macro:

```rust
fn main() {
    // initialize a mutable empty vector
    let mut mutable_vector = Vec::new();
    // push an element to the vector
    mutable_vector.push(1);
    println!("{:?}", mutable_vector);
    // use `vec!` macro to initialize a immutbale vector with three elements
    let immutable_vector = vec![2,3,4];
    println!("{:?}", immutable_vector);
}
```

### Capacity

**Recommended to specify capacity at declaration if possible**

* `capacity()` number of **allocated elements** (without reallocating)
* `len()` number of **used elements**
* `push()` and `insert()` never (re)allocate if capacity is sufficient
* `shrink_to_fit()` drops memory if able:

```rust
fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    vec.push(2);
    vec.pop();
    println!("{} {}",vec.capacity(),vec.len());
    vec.shrink_to_fit();
    println!("{} {}",vec.capacity(),vec.len());
}
```

### Iterators

`iter` provides an iterator of **immutable references**:

```rust
fn main() {
    let vector = vec![1,2,3];
    for element in vector.iter() {
        print!("{} ",element);
    }
}
```

`iter_mut` provides an iterator of **mutable references**:

```rust
fn main() {
    let mut vector = vec![1,2,3];
    for element in vector.iter_mut() {
        *element += 1;
        print!("{} ",element);
    }
}
```

## Strings

All strings in Rust are **UTF-8 encoded**.

```rust
fn main() {
    // string literal initalizing a `&str` slice
    let ss = "a";    // equivalent to `let ss: &str = "a"`
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

### Append

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

### Split

`split()` returns an iterator over substrings of a string slice:

```rust
fn main() {
    let s = "a,b,c";
    for t in s.split(",") {
        print!("{} ",t);
    }
}
```

`split_whitespace()` splits the input string into different strings

```rust
fn main() {
    let s = "a b   c";
    for t in s.split_whitespace() {
        print!("{},",t);
    }
}
```



