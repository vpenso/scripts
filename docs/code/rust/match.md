# Match

> Rust provides pattern matching via the `match` keyword, which can be used like a C `switch`.

> A `match` expression takes an input value, classifies it, and then jumps to code written to handle the identified class of data. [mmmmr]

```rust
for i in -2..5 {
    match i { //scrutinee is `i`
        -1 => println!("It's minus one"),
        1 => println!("It's a one"),
        2|4 => println!("It's either a two or a four"),
        _ => println!("Matched none of the arms"),
    }
}
```

The value compared to the patterns is called the **scrutinee**.

Scrutinee expression and patterns must have the same type.

```rust
let text = "foo bar nom".to_string();
for word in text.split(' ') {
match word.as_ref() {
    "foo" => {
	println!("bar");
    }
    "bar" => {
	println!("foo");
    }
    _ => println!("no match")
}
}
```

`match` can return a value:

```rust
let v = match 5 {
    1 => 2,
    2 => 3,
    _ => 0,
};
assert_eq!(v,0);
```

Match against an `enum` type:

```rust
enum E {
    A,
    B,
    C
}
let e = match E::C {
    E::A => 'a',
    E::B => 'b',
    E::C => 'c'
};
assert_eq!(e,'c')
```

# References

[mmmmr] Mixing matching, mutation, and moves in Rust  
<https://blog.rust-lang.org/2015/04/17/Enums-match-mutation-and-moves.html>
