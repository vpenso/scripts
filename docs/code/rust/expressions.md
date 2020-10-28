# Expressions

**place expression** represents a memory location

**value expression** represents an actual value

## Match

A `match` expression branches on a pattern.

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

* **scrutinee**, value to compare to the patterns
* scrutinee expression and patterns must have the same type

```rust
fn main() {
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
}
```
