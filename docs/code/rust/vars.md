# Variables

Rust is a **statically typed language**

* Use of `snake_case` for variable names by convention
* Compiler must know the types of all variables at compile time
* The **compiler can usually infer the type on assignment** 
  based on the value and how the are used (cf. Hindley–Milner type system)
* The `let` statement declares a variables in the current scope
* Variables in Rust are **immutable by default**
* Reassignable variables are declared with `let mut` (mutable)

Declare and initialize a variable with type inference:

```rust
fn main() {
    // declare, initialize variable
    let x = 1; // data type determined by the compiler
    println!("{}",x);
}
```
```
1
```

## Declaration

The `let` statement declares a variables in the current scope.

Local variables may not be initialized when allocated. 

```rust
fn main() {
    // declare variable, missing data type
    let x;
    println!("{}",x);
}
```
```
error[E0282]: type annotations needed
  |
2 |     let x;  // declare a local variable
  |         ^ consider giving `x` a type
```

Then it is necessary to define the data type with the declaration.

```rust
fn main() {
    // declare variable with data type
    let x: i32;
    println!("{}",x);
}
```
```
error[E0381]: borrow of possibly-uninitialized variable: `x`
  |
3 |     println!("{}",x);
  |                   ^ use of possibly-uninitialized `x`
```

Variables can only be accessed after a value has been assigned.

## Assignment

After declaration, a subsequent statement initialize the variable.

```rust
fn main() {
    let x: i32;  // declare variable
    x = 1;       // initialize variable
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

## Constants

> Constants aren’t just immutable by default - they’re always immutable.

Use the **`const` keyword** to declare compile-time constants

* `SCREAMING_SNAKE_CASE` names by convention
* Declared in any scope, including the global scope
* Constants must be **explicitly typed**

```rust
fn main() {
    const X: u8 = 1; // declare, initialize a contant with type
    println!("{}",X);
}
```

Compile complains about the mutable keyword with `const`:

```
error: const globals cannot be mutable
  |
2 |     const mut X: u8 = 1;
  |     ----- ^^^ cannot be mutable
  |     |
  |     help: you might want to declare a static instead: `static`
```

> Constants are essentially inlined wherever they are used, meaning that they
> are copied directly into the relevant context when used. 


## Mutable

**`mut`** keyword declares a variable reassignable

> `mut` conveys intent to future readers of the code by indicating that other
> parts of the code will be changing this variable’s value

```rust
fn main() {
    // declare, initialize a mutable variable
    let mut x = 1;
    println!("{} {:p}", x, &x);
    // assign new value
    x = 2;
    println!("{} {:p}", x, &x);
}
```

Mutable variables are just that – mutable. The value changes but the underlying
address in memory is the same:

```
1 0x7ffd1cd3dce4
2 0x7ffd1cd3dce4
```

> There are multiple trade-offs to consider in addition to the prevention of
> bugs. For example, in cases where you’re using large data structures, mutating
> an instance in place may be faster than copying and returning newly allocated
> instances. With smaller data structures, creating new instances and writing in
> a more functional programming style may be easier to think through, so lower
> performance might be a worthwhile penalty for gaining that clarity.
