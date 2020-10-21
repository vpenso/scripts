# Ownership

Tight coupling between assignment and ownership.

* Code analyses to check a standard set of safe code conventions
* Rust enforces [Resource acquisition is initialization][raii] (RAII)
  - Automatic and predictable release of resources (drop)
  - Prevents bugs associated with resource leak
  - No need to manually free memory
  - No garbage collection
* Variable lifetime spans from declaration until compiler infers it can be dropped
* Drop of a variable includes all resources which it has ownership of
* Notion of a destructor in Rust is provided through the `Drop` trait

[raii]: https://en.wikipedia.org/wiki/Resource_acquisition_is_initialization

Rust uses [lexical scopes][ls] - name resolution depends on the location in
the source code and the lexical context.

[ls]: https://en.wikipedia.org/wiki/Scope_(computer_science)#Lexical_scope_vs._dynamic_scope

```rust
fn main() {
    { // anonymous scope created
        let x = 1;
    } // drop value of x
    println!("{}", x);
}
```
```
error[E0425]: cannot find value `x` in this scope
  |
5 |     println!("{}", x);
  |
```

Rust enforces three simple **rules of ownership**:

1. Each value has a variable which is the owner.
2. Each value has exactly one owner at a time.
3. When the owner goes out of scope the value is dropped 

```rust
fn main() {
    let x = "a".to_string();
    let y = x;    // move ownership
    let z = x;    // previous owner can no longer be used
    println!("{}", z);
}
```

The compiler complains about the ownership 

```
error[E0382]: use of moved value: `x`
  |
2 |     let x = "a".to_string();
  |         - move occurs because `x` has type `std::string::String`, which does not implement the `Copy` trait
3 |     let y = x;
  |             - value moved here
4 |     let z = x;
  |             ^ value used here after move
```


# Borrowing

> Given that there are rules about only having one mutable pointer to a variable
> binding at a time, rust employs a concept of borrowing.

One piece of data can be borrowed either as a shared borrow or as a mutable
borrow at a given time (not both at the same time).

## Shared Borrowing

Data is borrowed by a single or multiple users. 

**Data can not be altered, but is readable by all users.**

```rust
fn main() {
    let a = [1,2,3,4,5];
    let b = &a;                   // shared borrow of `a`
    println!("{:?} {}", a, b[1]);
}
```
```
[1, 2, 3, 4, 5] 2
```

## Mutable Borrowing

Data can be borrowed and **altered by a single user**.


```rust
fn main() {
    let mut a = [1,2,3,4,5];
    let b = &mut a;         // mutable borrowing of `a`
    b[0] = 6;               // ⁝
                            // ...ends here
    println!("{:?}", a);
}
```
```
[6, 2, 3, 4, 5]
```

**Data not accessible for any other users** at that time.

```rust
fn main() {
    let mut a = [1,2,3,4,5];
    let b = &mut a;          // mutable borrowing of `a`
    a[1] = 7;                // ⁝
    println!("{:?}", b);     // ...ends here
}
```
```
error[E0503]: cannot use `a` because it was mutably borrowed
  |
3 |     let b = &mut a;
  |             ------ borrow of `a` occurs here
4 |     a[1] = 7;
  |     ^^^^ use of borrowed `a`
5 |     println!("{:?}", b);
  |                      - borrow later used here
```
