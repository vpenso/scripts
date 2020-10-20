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

Variables can **only be accessed after a value has been assigned**.

Assignment after declaration by a subsequent statement initialize the variable.

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

> We get the primary benefit we want from immutable-by-default: mutable code is
> explicitly called out, so you know where to look for bugs.

> Reducing the number of mutable variables in code makes its understanding
> infinitely easier because you know that once a variable has been given a
> value, it remains that way. You don’t need to carefully look for places where
> the value might be mutated...in practice you end up passing lots of values by
> reference to avoid copy costs. In those cases, it’s very useful to know that
> calling a specific function won’t mutate its arguments


## Shadowing

Multiple variables can be defined with the same name, which **masks 
access to a previosly declared varriables** beyond the point of shadowing

> Shadowing is different from marking a variable as `mut`, because we’ll get a
> compile-time error if we accidentally try to reassign to this variable without
> using the `let` keyword. By using `let`, we can perform a few transformations
> on a value but have the variable be immutable after those transformations have
> been completed.

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

No effect on original variable `x` becomes more evident with scopes:

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


> Rust cares about protecting against unwanted mutation effects as observed
> through references. This doesn't conflict with allowing shadowing, because
> you're not changing values when you shadow, you're just changing what a
> particular name means in a way that cannot be observed anywhere else.
> Shadowing is a strictly local change.

## Rebind

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

> Mutability is a necessary component of software development. At the lowest
> level of software, machine code is inherently mutable (mutating memory and
> register values). We layer abstractions of immutability on top of that...

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

# Ownership

Tight coupling between assignment and ownership

Rust enforces three simple rules of ownership:

1. Each value has a variable which is the owner.
2. Each value has exactly one owner at a time.
3. When the owner goes out of scope the value is dropped 

Rust uses [lexical scopes][ls] where name resolution depends on the location in
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


## Borrowing

> Given that there are rules about only having one mutable pointer to a variable
> binding at a time, rust employs a concept of borrowing.



# References

[01] Memory Safety in Rust: A Case Study with C  
<https://willcrichton.net/notes/rust-memory-safety/>

[02] A closer look at Ownership in Rust  
<https://blog.thoughtram.io/ownership-in-rust/>

[03] The Rust Programming Book - What is Ownership?  
<https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html>
