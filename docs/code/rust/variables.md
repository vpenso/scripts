# Literals

```rust
1                // integer
100_000_000      // _ visual separator, equals 1000000
1.2              // floating point
3.141_592        // equals 3.145592
0xff             // hex
0o77             // octal
0b1111_0000      // binary
b'A'             // byte (u8 only)
'a'              // character
```

Number literals except the byte literal allow a **data type suffix**:

```rust
123i32       // type i32
57u8         // type u8
123.0f64     // type f64
12E+99_f64   // scientific notation for type f64
0xff_u8      // hex type u8
0o70_i16     // octal type i16
```

# Variables

Rust is a **statically typed language**.

Every value in Rust is of a certain data type.

* Use of `snake_case` for variable names by convention
* Compiler must know the types of all variables at compile time
* The **compiler can usually infer the type on assignment** 
  based on the value and how the are used (cf. Hindley–Milner type system)
* The `let` statement declares a variables in the current scope

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

Rust uses the **stack by default for static values**.

Static data (size known at compile time) includes:

* Function frames
* Scalar (integer, float, etc) & compound types (tuples, arrays)
* Structs and pointers to dynamic data in the heap

[Collections](collections.md) cannot be stack based since the are dynamic in
size by nature, and are therefore stored in the heap.

## Scalar Types

**Primitive** data types that represents a **single value**

* Integer number without a fractional component
  - Signed integer types start with `i`, and unsigned with `u`
  - 8,16,32,64,128 bit variants, i.e. `i32` (signed 32 bit integer)
* `isize` and `usize` types depend on architecture
  - Pointer sized signed and unsigned integer types
  - 32 bits on 32-bit platforms and 64 bits on 64-bit platforms
* Floating-point types are `f32` and `f64`, which are 32 bits and 64 bits in size
* One byte Boolean type `bool` with two values: `true` and `false`
* `char` character type, specified with single quotes `'ℤ'`

```rust
let x = 10;         // default integer type is i32
let y: i8 = -128;
let a = 5i8;        // Equals to `let a: i8 = 5;`
let x = 1.5;        // default float type is f64
let y: f32 = 2.0;
```

Most primitives implement the **`Copy` trait**

* Can be moved without owning the value in question
* Copied byte-for-byte in memory to produce a new, identical value

## Compound Types

**Group multiple values** into one type

**Tuple** groups a number of values with a variety of types

```rust
// comma-separated list of values inside parentheses
let t = (500, 6.4, 1);
// access elements directly using a period
let x = t.0                                // index starts at zero
// with type annotation
let t: (i32, f64, u8) = (500, 6.4, 1);     
// desctruct tuple into three separate variables
let (x, y, z) = t;
```

**Array** in Rust have a **fixed length** (like tuples):

- Arrays are allocated **on the stack**.
- Even with `mut`, its element count cannot be changed.
- The `Vec<T>` standard library type provides a heap-allocated resizable array
  type.

```rust
// comma-separated list inside square brackets
let a = [1, 2, 3, 4, 5];
// define a type, and size
let a: [i32; 5] = [1, 2, 3, 4, 5];
// initial value, size
let a = [3; 5]; // expands to [3, 3, 3, 3, 3]
// access elements of an array using indexing
let mut c: [i32; 3] = [1, 2, 3];
c[0] = 2;
c[1] = 4;
c[2] = 6;
```

**Slices**

```rust
let a: [i32; 4] = [1, 2, 3, 4]; // Parent Array
let b: &[i32] = &a;             // Slicing whole array
let c = &a[0..4];               // From 0th position to 4th(excluding)
let d = &a[..];                 // Slicing whole array
let e = &a[1..3];               // [2, 3]
let f = &a[1..];                // [2, 3, 4]
let g = &a[..3];                // [1, 2, 3]
```



# Declaration

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

If data type inference is not possible, then it is **required to define 
the data type** with the declaration.

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

# Immutability

Variables in Rust are **immutable by default**:

> We get the primary benefit we want from immutable-by-default: mutable code is
> explicitly called out, so you know where to look for bugs.

Example of an assignment to an immutable variable:

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

> Reducing the number of mutable variables in code makes its understanding
> infinitely easier because you know that once a variable has been given a
> value, it remains that way. You don’t need to carefully look for places where
> the value might be mutated...in practice you end up passing lots of values by
> reference to avoid copy costs. In those cases, it’s very useful to know that
> calling a specific function won’t mutate its arguments

The compile warns about mutable variables which never get a reassignment:

```rust
fn main() {
    let mut a = 1;
    println!("{}", a);
}
```
```
warning: variable does not need to be mutable
 --> vars.rs:2:9
  |
2 |     let mut a = 1;
  |         ----^
  |         |
  |         help: remove this `mut`
  |
```

## Constants

> Constants aren’t just immutable by default - they’re always immutable.

Use the **`const` keyword** to declare compile-time constants

* `SCREAMING_SNAKE_CASE` names by convention
* Declared in any scope, including the global scope
* Constants must be **explicitly typed**

```rust
fn main() {
    const X: u8 = 1; // declare, initialize a constant with type
    println!("{}",X);
}
```

Compiler complains about the mutable keyword with `const`:

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
    let x = 2;  // rebind
    println!("{} {:p}",x,&x);
}
```
```
1 0x7ffd246f56ac
2 0x7ffd246f571c
```

Note that the variable uses a different memory address when recycled.

# Mutability

Re-assignable variables are declared with `let mut` (mutable)

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
