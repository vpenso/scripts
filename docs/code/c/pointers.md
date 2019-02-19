
# Pointers


Pointers are variables that contain the **address of another variable in memory**:

- A pointer must us the same associated type as variable it points to
- Pointers must be initialized before being used.
- Declare a pointer with the unary `*` (asterisk) operator
- `NULL` indicates that a pointer does not point anywhere
- Pointers are given a value with the `&` (ampersand) operator
- Pointers are dereferenced with the `*` operator
- Casting pointers changes its type but not its value
- Pointers can point to functions

```c
T *p;                           // declare pointer p of type T
NULL                            // null pointer constant
*p                              // object pointed to by pointer p
&x                              // address of object x 
p = &x;                         // assign address of object x to pointer p
T v = *p;                       // assign value to variable v addressed by pointer p of type T
T *p[N];                        // pointer p is an array of size N of pointers to T
T **p;                          // p is a pointer to a pointer to a value of type T
T *f();                         // f is a function returning a pointer of type T
T (*pf)();                      // pf is a pointer to a function returning type T
```

