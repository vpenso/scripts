# C Programming Language

A C program is characterized by:

* Code stored in files with suffix `*.c`
* Shared declarations (included with `#include`) in **header** with suffix `*.h`
* Whitespace (space, tab, blank line, etc ) is ignores, with minor exceptions
* C is **case-sensitive**
* Keywords are lower case, can't be used for any other purpose
* **Statements**, C instructions must end with comma `;` (statement terminator)

```
;                            statement terminator
e                            expression, combination of operands & operators
s;                           statement, C instruction, ends with semicolon
{}                           statement block, groups of statements
/**/                         multi-line comment
//                           line comment
```

## Variables

### Declaration & Initialisation

* Must be **declared** before they can be used in a program
* Have a name as **identifier** composed from the following characters `A-Za-z0-9_`
* Each variable is of a specific **data-type**
* Declared variables must be **initialized** using the assignment operator "="
* The assigning **value** can be derived from a constant, literal, expression or statement

```
T v;                         declare variable with identifier v of data type T
T v,w,x,y,z;                 declare multiple variables
T v = V;                     initialize variable v with value V
const T v;                   declare contat variable
T a[S];                      declare array a of type T with size S
sizeof(v)                    return size of variable v in addressable units (bytes)
&v                           return address of variable
*v                           pointer to variable v
```

* The variable value can be changed at any time, hence is **volatile**
* **Constant** variables are protected from change and declared with the keyword `const`
* Basic data types support **arrays** of those types declared with suffix square braces "[]"
* `static` variable inside a function keep their value between invocations.
* `static` global variable (or a function) is "seen" only in the file it's declared in


### Types

Basic data types [`T`]

* Boolean values are just integers (false → 0 (zero), true → anything non-zero)
* Integers are signed by default use `signed`/`unsigned` to clarify

```
void                         type for functions returning nothing 
char                         -128 to 127
unsigned char                0 - 255
byte                         0 - 255
bool                         logic true, false
int                          -32768 to 32768
unsigned int                 0 to 65535
long                         –2147483648 to 2147483647
unsigned long                0 to 4294967295
float                        –3.4028235E+38 to 3.4028235E+38
```

### Literals

Basic literals for values [`V`]:

```c
0123                         // octal
0x1a                         // hexadecimal
42                           // decimale
42u                          // unsigned int
42l                          // long
42ul                         // unsigned long
4.2                          // float
4234E-5L                     // float scientific notation
'a'                          // char (enclosed in single qoutes)
'\t'                         // char escape sequence, newline \n, tab \t
'\u02C0'                     // char unicode
```

### Array

Finite set of variables with the same type:

* The C compiler **does not** check array bounds!
* Size `N` (number of elements) declared in square brackets `[]`
* Array elements are indexed starting with 0 (zero), last element is N-1

```c
T a[N];                      // declare array a of type T with N elements
a[i] = v;                    // assign value v to array a element i
T v = a[0];                  // assign first element of array a to variable v
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

## Operators

Arithmetic, relational, logic and binary operators

```
+        plus
-        minus
*        multiply
/        divide
%        modulus
++       increment
--       decrement
>        greater than
>=       greater than or equal to
<        less than
<=       less than or equal to
==       equal to
!=       not equal to
&&       logic and
||       logic or
!        logic not (negate)
&        binary and
|        binary or
^        binary xor
~        binary complement (bit flip)
<<       binary left shift
>>       binary right shift
```

Assignment operators

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

## Control Structures

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

## Functions

A function is a pointer to some code:

* Must be declared before they are use in the code
* Identified by a function **name** [f] followed by the function **arguments** [a] in parentheses
* Use arguments to pass data into the function, multiple arguments are delineated by comma
* Functions may `return` a value corresponding to the function **type specifier** [T]
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
* A _cohesive function_ is designed to accomplish a single taskQ
* Functions use the **call by value** method send values of a variable argument

### Program Main-Function

Each valid C program require a main function with on of the following signatures:

```
int main(void)
int main(int argc, char **argv)
int main(int argc, char *argv[])
```

**The main function is the starting point of the program.**

* Program parameters can be accessed as strings through the `argv` array with `argc` elements. (#1 program file name)
* The integer `return`-value of main() is send to the operating system es **exit status**.

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
