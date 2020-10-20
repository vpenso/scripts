Rust is a **statically typed language**

* Use of `snake_case` for variable names by convention
* Compiler must know the types of all variables at compile time
* The **compiler can usually infer the type on assignment** 
  based on the value and how we use it (cf. Hindley–Milner type system)
* The `let` statement declares a variables in the current scope
* Variables in Rust are **immutable by default**

Declare and initialize a variable with type inference:

```rust
fn main() {
    let x = 1; // a single variable
    println!("{}",x);
}
```
```
1
```

## Declaration

The `let` statement declares a variables in the current scope:

```rust
fn main() {
    let x;  // declare a local variable
    println!("{}",x);
}
```
```
error[E0282]: type annotations needed
  |
2 |     let x;  // declare a local variable
  |         ^ consider giving `x` a type
```

Local variables may not be initialized when allocated. Then it is necessary to
define the data type with the declaration.

```rust
fn main() {
    let x: i32;  // declare a local variable with type
    println!("{}",x);
}
```
```
error[E0381]: borrow of possibly-uninitialized variable: `x`
  |
3 |     println!("{}",x);
  |                   ^ use of possibly-uninitialized `x`
```

## Assignment

Variables can only be accessed after a value has been assigned.
Therefore a subsequent statement needs to initialize the variable.

```rust
fn main() {
    let x: i32;  // declare a local variable
    x = 1;       // asign a value to variable
    println!("{}",x);
}
```
```
1
```

## Immutable

Variables in Rust are immutable by default:

```rust
fn main() {
    let x = 1;  // declare variable
    x = 2;      // assign to immutable variable
    println!("{}",x);
}
```

Compile-time error by an attempt to change a value of an immutable variable:

```
error[E0384]: cannot assign twice to immutable variable `x`
  |
2 |     let x = 1;  // a single variable
  |         -
  |         |
  |         first assignment to `x`
  |         help: make this binding mutable: `mut x`
3 |     x = 2;
  |     ^^^^^ cannot assign twice to immutable variable
```


---

## Shadowing

Multiple variables can be defined with the same name:

* Variable shadowing, aka name masking
* Unable to directly access it beyond the point of shadowing

```rust
fn main() {
    let x = 1;  // declare variable
    let x = 2;  // mask x
    println!("{}",x);
}
```
```
2
```

Compiles with warning:

```
warning: unused variable: `x`
  |
2 |     let x = 1;  // declare variable
  |         ^ help: consider prefixing with an underscore: `_x`
  |
  = note: `#[warn(unused_variables)]` on by default
```

No effect on original variable `x`:

```rust
fn main() {
    let x = 1;  // declare variable
    { // start new scope
        let x = 2; // masks out-scope x
        println!("{}",x);
    }
    println!("{}",x);
}
```
```
2
1
```

> Shadowing is different from marking a variable as `mut`, because we’ll get a
> compile-time error if we accidentally try to reassign to this variable without
> using the `let` keyword. By using `let`, we can perform a few transformations
> on a value but have the variable be immutable after those transformations have
> been completed.

## Rebinding Variable Names

If a variable has been declared and used, it is possible to recycle the variable
name by a new variable declaration statement:

```rust
fn main() {
    let x = 1;  // declare
    println!("{} {:p}",x,&x);
    let x = 2;  // recycle
    println!("{} {:p}",x,&x);
}
```
```
1 0x7ffd246f56ac
2 0x7ffd246f571c
```

Note that the variable uses a different memory address when recycled.

## Mutable

`mut` keyword declares a variable 

```rust
fn main() {
    let mut x = 1;  // declare
    println!("{}",x);
    x = 2;          // assign value
    println!("{}",x);
}
```
```
1
2
```
