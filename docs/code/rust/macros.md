
```rust
fn add(x: i32, y: i32) -> i32 {
    x + y
}

macro_rules! add {

    ($x:expr,$y:expr) => {
        add($x,$y)
    };

    ($x:expr) => {
        add($x,2)
    };

    () => {
        add(1,2)
    };
}

fn main() {
    assert_eq!(add!(),3);
    assert_eq!(add!(1),3);
    assert_eq!(add!(1,2),3);
}
```
