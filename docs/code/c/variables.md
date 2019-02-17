
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

