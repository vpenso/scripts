## Functions

The **`main` function is the program entry point**


```rust
// program entry point
fn main() {
   // call the `add` function
   print!("{}",add(1,2));
}
// function with parameters, and a return value
fn add(x: i32, y: i32) -> i32 {
   // function body
   x + y // last expression used for return value
}
```

**Declare new functions with `fn`** keyword followed by:

* **`snake_case` function name**
* Input **parameter list in `()`** passed by the caller
* **Function body in `{}`** containing statements and expressions
  - Statements do not return values
  - Expressions evaluate to something and return a value (no ending semicolon)

Parameters are variables that are part of a function’s signature:

* **Must declare the type of each parameter**
* Multiple parameters separated by `,`

Functions can **return values** to the code that calls them

* Declare type of a return value with `->`
* Return value synonymous with the value of the **final expression**

```rust
// a function with mutliple return values
fn add_sub(x: i32, y: i32) -> (i32, i32) {
    (x + y, x -y)
}
fn main() {
    print!("{:?}",add_sub(1,2));
}
```
