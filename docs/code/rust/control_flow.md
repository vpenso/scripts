# Control Flow

## Conditions

Evaluate a block `if` a condition holds.

```rust
fn main() {

    let number = 5;

    if number < 10 {
        println!("first condition true");
    } else if number < 22 {
        println!("second confition ture");
    } else {
        println!("condition was false");
    }
}
```

`if` blocks can also act as expressions if all branches return the same type

```rust
let answer = if 1 == 2 {
    "whoops, mathematics broke"
} else {
    "everything's fine!"
}
```

## Loops

The `loop` keyword runs endless...

* ..until a `break` keyword stops the loop
* a value after `break` will be returned

```rust
fn main() {
    let mut counter = 0;
    let result = loop {
       counter += 1;
       if counter == 10 {
           break counter;
       }
    };
    println!("Looped {} times",result);
}
```


`while` loop begins by evaluating the boolean loop conditional expression...

* ...returns if the condition becomes `true`:

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
