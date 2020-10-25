## References

TODO

## Smart Pointers

TODO

## Raw Pointers

> ..give up guaranteed safety in exchange for greater performance or the ability
> to interface with another language or hardware where Rust’s guarantees don’t
> apply.

Can be immutable `*const T` or mutable `*mut T`

* Asterisk is part of the type name
* **Ignore the borrowing rules** (multiple mutable pointers to the same location)
* **No guarantee to point to valid memory**
* Allowed to be null
* No automatic cleanup

```rust
// create a raw pointer to an arbitrary location in memory
let rp = 0xb8000 as *mut u8;
// use arbitrary memory is undefined!
```
```
