# C Programming Language

Building blocks of the C programming language:

* **Variables**
* **Operators**
* **Expressions**
* **Statements**
* **Statement Blocks**
* **Function Blocks**

## Variables

_A variable is a symbolic name for (or reference to) information. The information associated to (value of) the variable can changes while the variable name is the same in a program._

Variables properties:

* **Name**: The identifier of the variable
* **Value**: Data associated to the variable
* **Address**: Location of its value in memory
* **Type**: Interpretation of the value (its "kind" of data)
* **Scope**:  Region of the program where a defined variable is visible

Interaction with a variable:

* **Declaration**: States the type of a variable, along with its name.
  - Variables can be declared only once.
  - A variable requires to be declared before assigning a value.
* **Initialization**: The first assignment of a value to a variable.
* **Assignment**: Overwriting the value of a variable.
* **Access**: Read the stored value of a variable.

### Types

A type defines the kind of possible values a variable can represent.

- Numbers
- Booleans (true/valus values)
- Characters
- Arrays (a list of data of the same type)
- Structures (a collection of named data referring to a single entity)

Incomplete list of [data types with value range in C](https://en.m.wikipedia.org/wiki/C_data_types):

```
int                          -32768 - 32768
long                         –2147483648 - 2147483647
float                        –3.4028235E+38 - 3.4028235E+38
bool                         0 or1
char                         -128 - 127
byte                         0 - 255
unsigned char                0 - 255
unsigned int                 0 - 65535
unsigned long                0 - 4294967295
void                         no value
```

* `int` (integers) are natural numbers
* `long` are integers with higher precision
* `float` (floating point) are real numbers with a decimal point
* `bool` values are just integers (`false` → 0 (zero), `true` → anything non-zero)
* Integers are signed by default use `signed`/`unsigned` to clarify
* `void` is a type with no value (untyped pointers, function with no return value)

### Literals

A literal is a notation for representing a fixed value in source code

* Often used to initialize variables.
* **Suffixes** indicate the type i.e. `u` (unsigned)
* **Prefixes** indicate the base (numeral system) `0` (octal), `0x` (hexadecimal).

Basic number literals:

```c
// decimal numbers
42                           // integer literal
42u                          // unsigned integer literal
42l                          // long integer literal
42ul                         // unsigned long integer literal
4.2                          // float numbner
4234E-5L                     // float scientific notation
// other numeral systems
0123                         // octal
0x1a                         // hexadecimal
```

Character literals:

* Use a single quote `'` for expressing the character
* The character is encoded using the [ASCII](https://en.m.wikipedia.org/wiki/ASCII)
* [Escape characters](https://en.m.wikipedia.org/wiki/Escape_character) alternate the interpretation of a character

```c
'a'                          // enclosed in single qoutes
'\t'                         // char escape sequence, newline \n, tab \t
'\u02C0'                     // unicode character
```

### Declaration

A variable must be declared before it can be used in a program:

* Identifier are composed from the following characters `A-Za-z0-9_`.
* Each variable is of a specific data-type `T`
* Declared variables must be initialized using the **assignment operator**.
* A value `V` can be derived from a constant, literal, expression or statement.

```
T v;                         define a variable with identifier v of data type T
T v,w,x,y,z;                 define multiple variables
T v = V;                     declare variable v with value V
const T v;                   define contat variable
T a[S];                      define array a of type T with size S
```

* The variable value can be changed at any time, hence is **volatile**.
* Variable declared `const` (constant) can not be overwritten.
* `static` variable inside a function keep their value between invocations.
* `static` global variable (or a function) is "seen" only in the file it's declared in

### Arrays

Finite set of variables with the same type:

* The C compiler **does not** check array bounds!
* Size `N` (number of elements) declared in square brackets `[]`
* Array elements are indexed starting with 0 (zero), last element is N-1

```c
T a[N];                      // declare array a of type T with N elements
a[i] = v;                    // assign value v to array a element i
T v = a[0];                  // assign first element of array a to variable v
T a[N][M];                   // declare a multidimensional array of size NxM
// Examples
int a[3] = {0,1,2};          // define & initialize
int a[4] = {0,1};            // initialize 0,1,0,0
float a[10] = {0};           // all elements 0.0
int a[2][2] = {{1,2},{3,4}}  // define & initialize a 2-dimensional array
```

### Strings

Strings, sequences of characters (text):

```
"text"                       string literal
char s[S];                   character array with identifier s of size S 
                             implicit termination null character \0
char s[] = "text";           declare and initialize a character array s
char s[] = {'a','b'};        intialize with a list of char in braces {}
```

The String data type supports a list of built-in functions

```
String s = String(S);        define a String object s of size S
charAt()                     access a character at a specified index
compareTo()                  compare two Strings
concat()                     append one String to another String
endsWith()                   get the last character in the String
equals()                     compare two Strings
equalsIgnoreCase()           compare two Strings, but ignore case differences
getBytes()                   copies a String into a byte array
indexOf()                    get the index of a specified character
lastIndexOf()                get the index of the last occurrence of a specified character
length()                     the number of characters in the String, excluding the null character
replace()                    replace one given character with another given character
setCharAt()                  change the character at a specific index
startsWith()                 does one String begin with a specified sequence of characters?
substring()                  find a substring within a String
toCharArray()                change from String to character array
toLowerCase()                change all characters to lower case
toUpperCase()                change all characters to upper case
trim()                       remove all whitespace characters from a String.
```

### Type Cast

Used to coerce on data type into another data type

* Most C types can be cast to another
* Use a **cast operator** in front of the data item 
* The cast operator places the desired type between parentheses `(T)`
* Prevent **silent casts** by always using a cast as assignment statement between two data types

```
T v = (T) w;                    // cast w to type T before assignment
// Examples
int v = (int) w;                // variable W becomes an int before assignment to v
long v = (long) w;              // cast into long
```

# Expressions & Statements

An expression is created by combining operands and operators:

* **Operand**: A piece of data that is acted on by an operator.
* **Operator**: Mathematical or logical performed on one or more operands. 
* **Operator precedence**: Order in which complex expressions are resolved

A statement is a complete C instruction for the computer:

* Smallest element that expresses an action to be carried out
* End with a semicolon `;` as **statement terminator**.

Statements are **executed**, while expressions are **evaluated**.

### Assignment

Assign the value on the right side of the equal sign to the operand on the left side.

List of assignment operators:

```
=        simple
+=       add
-=       subtract
*=       multiply
/=       divide
%=       modulus
<<=      left shift
>>=      right shift
&=       bitwise
^=       exclusive or
|=       inclusive or
```

* All assignment operators include the **equal sign `=`**
* Used to assign a value to a variable.
* Operates on two operands: **L-Value** and **R-Value** (left/right of the equal sign).
* Lower precedence than other available operators.

For example:

```c
int v = 1;     // assign value 1 to variable v
v += 1;        // v = v + 1
```

### Arithmetic

```
+        plus
-        minus
*        multiply
/        divide
%        modulus
++       increment
--       decrement
```

### Relational

List of relational operators:

```
>        greater than
>=       greater than or equal to
<        less than
<=       less than or equal to
==       equal to
!=       not equal to
&&       logic and
||       logic or
!        logic not (negate)
```

* Compare the state of two or more pieces of data.
* Result is either logic true or false

For example:

```c
2 > 1             // true
2 < 1             // false
2 == 1            // false
2 != 1            // true
1 < 2 && 2 < 3    // true
```

### Binary 

```
&        and
|        or
^        xor
~        complement (bit flip)
<<       left shift
>>       right shift
```

## Statement Blocks

A statement block consists of one or more statements grouped together.

* Often called control structures.
* Start with opening brace character ~{~ and end with closing brace character `}`.

**If** statement:

* If the expression `e` in parenthesis evaluates to `true` execute (block) statement
* Expression assumed `true` if it evaluates to non-zero

```c
e ? X : Y                    // ternary operator
if (e) s;                    // single statement
if (e) {}                    // block statements
else if (e) {} 
else {}            
```

**Switch** statement:

```c
switch (e) {
  case v:
    // statements to execute when expression e equals v
    break;
  case W: 
    // statements to execute when expression e equals w
    break;
  // more case statements as needed
  default:
    // if expression e does not have a case value
    break;
}
```

**Loop** constructs:

* `while` repeats the block statement unit the expression `e` evaluates to `false` (0)
* `for` use a specific syntax in parentheses, where `i` initialises a variable, `c` is a conditional expression, and `m` modifies the variable (typically by increment)
* `do .. while` check for the conditional expression after executing the code once

```c
while (e) {}                 // simple loop
for( i; c; m) {}             // iterator loop
do {} while(e);               
break                        // exit from a loop
continue                     // skip one iteration of loop
```

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

# Functions

A function is a pointer to some code:

* Must be declared before they are use in the code
* Identified by a function **name** [`f`] followed by the function **arguments** [`a`] in parentheses
* Use arguments to pass data into the function, multiple arguments are delineated by comma
* Functions may `return` a value corresponding to the function **type specifier** [`T`]
* The statement code block associated to the function is called function **body**
* The function body can `return` a value `v` to the function caller
* Functions without a return value use `void` as type specifier

```
T f();                       // declare a function (empty argument list)
T f(a) {}                    // function with name f, argument a, and a return type T 
T f(a,b,c) {}                // function with argument list
return v;                    // exists function, and return value v 
f();                         // function call
```

* Function return type, name, and arguments are called the function **signature**
* **Overloaded** functions have the same name, but differ in their return type and/or argument list
* Functions should use _task-oriented names_ to reflect their purpose
* A _cohesive function_ is designed to accomplish a single task

### Common I/O Functions

Default input/output functions are declared in **stdio**: `#include <stdio.h>`

```
fopen(name, “r”)              opens file name for read, returns FILE *f; “w” allows write
fclose(f)                     closes file f
getchar()                     read 1 char from stdin or pushback; is EOF (int -1) if none
ungetch(c)                    pushback char c into stdin for re-reading; don’t change c
putchar(c)                    write 1 char, c, to stdout
fgetc(f)                      same as getchar(), but reads from file f
ungetc(c,f)                   same as ungetchar() but onto file f
fputc(c,f)                    same as putchar(c), but onto file f
fgets(s,n, f)                 read string of n-1 chars to a s from f or til eof or \n 
fputs(s,f)                    writes string s to f: e.g. fputs(“Hello world\n”, stdout);
scanf(p,...)                  reads ... args using format p (below); put &w/non-pointers
printf(p, ...)                write ... args using format p (below); pass args as is
fprintf(f,p,...)              same, but print to file f
fscanf(f,p,...)               same, but read from file f
sscanf(s,p,...)               same, but read from string s
sprintf(s,p,...)              same, as printf, but to string s
feof(f)                       return true if at end of file f
```

**Format specification** [p] characters preceded by escape `%`

```
%c                            character
%d                            decimal integer
%s                            string
%g                            float
%e                            scientific notation
%o                            unsigned octal
%x                            unsigned hex
\n                            new line 
\t                            tab
\\                            literal slash
%%                            literal percent
```

## Structure

Collect several data fields into a single logical _data structure_:

* Declare a data structure with the `struct` **keyword** followed by an **structure tag** (identifier)
* The identifier follows the same rules as C variables
* Within the braces _one or more variable definitions_ are expected, these are called **structure members**

```
struct s { u; v; w; };        // define a struct with name s with values u,v,w
struct s { u; v; } t;         // define a struct s and declare a variable t of struct type s
struct { u; v; w; } s,t;      // declare a structure s and t with members u,v,w
struct s v;                   // declare a variable v of struct type s
struct s v[n];                // declare an array v of struct type s with size n
v = s.u;                      // read structure member u
s.u = v;                      // write structure member u
```

* Use the **dot operator** `.` to access structure members
* Write values to a member by using the dot operator on the left side of an assignment


# Compile

The **GCC** (GNU Compiler Collection) is one of the most widely used compilers for C.

Simple C program `h.c`:

```c
#include <stdio.h>      // header file including library functions

// Every program has to have a "main" function
int main(void)
{
   // Generic function for printing formatted strings
   printf("Hello\n");
   // Exit the main function
   return 0;
}
```

The command `gcc` is used to compile code for the x86 architecture:

```bash
gcc h.c                         # compile, executable `a.out`
    -v ...                      # print executed commands
    -o h h.c                    # specifiy output file name with option -o
    -Wall ...                   # enable all warnings
    -Werror                     # convert warning into errors
    -E h.c > h.i                # produce only the preprocessor output
    -S h.c                      # produce only assembly code `h.s`
    -C h.c                      # compile without linking
    -save-temps h.c             # preservers intermediat files
    -ansi ...                   # enable ISO C89 support
    @opt_file                   # use an options file `opt_file` 
```

* Source code stored in files with suffix `.c`
* Shared declarations (included with `#include`) stored in **header** files with suffix `.h`

## Workflow

From source code to an executable binary:

1. **Preprocessor**: Macro substitution, include header files.
2. **C Compiler**: Compile each C file into assembly language.
3. **Assembler**: Assemble each file into object code.
4. **Linker**: Link object files into program binary (executable code).

```bash
>>> gcc -save-temps -o h h.c && ls -1
h*                    # executable binary
h.c                   # source code
h.i                   # preprocessor output
h.o                   # object code
h.s                   # assembly code
>>> ./h    
Hello
```

Assembly code vs Machine code vs Object code:

* **Maschine Code**: Binary code (1's and 0's) that can be executed directly by the CPU.
* **Object Code**: Machine code not linked into a complete program yet. May contain information (placeholders, relocation information, symbol tables) used by the linker to build the executable.
* **Assembly Code**: Human read-able code mostly direct 1:1 analog with (hardware specific) machine instructions. This is accomplished using mnemonics for the actual instructions/registers/other resources. (Unlike Machine Code, the CPU does not understand Assembly Code.)

## Preprocessor

Include "header" files in the source code:

* Basic mechanism to define an _Application Programming Interface_ (API)
* Included files can include other files

```c
#include <f.h>           // <> used for system headers
#include "g.h"           // "" used for application specific headers
```

Token-based macro substitution:

```c
#define I T             // object-like macro replacing identifier I with replacment token list T
#define I(p) T          // function-like macro with a parameters list p
#undef I                // delete the macro by identifier I
// Examples:
#define PI 3.14159      // create symbolic names for constants
#define INC(x) (x+1)    // function-like macro
INC(2)                  // replaced with 2+1 (not 3)
```

Conditional compilation:

```c
#if e                   // evaluates expression e
#ifdef I                // if identifier I is defined
#ifndef I               // if identifier I is not defined
  ...
#elif e                 // evaluate expression e
  ...
#else
  ...
#endif
```

## Main Function

Each valid C program require a main function with on of the following signatures:

```c
int main(void)
int main(int argc, char **argv)
int main(int argc, char *argv[])
```

**The main function is the starting point of the program.**

* Program parameters can be accessed as strings through the `argv` array with `argc` elements. (#1 program file name)
* The integer `return`-value of main() is send to the operating system es **exit status**.

Program to print arguments from the command line:

```c
#include <stdio.h>

int main(int argc, char **argv)
{
   int i;
   printf("argc = %d\n", argc);
   for (i=0; i < argc; ++i)
     printf("argv[%d]: %s\n", i, argv[i]);
   return 0;
}
```
```bash
>>> ./args 1 "ab" 2 "cd"
argc = 5
argv[0]: ./args
argv[1]: 1
argv[2]: ab
argv[3]: 2
argv[4]: cd
```

