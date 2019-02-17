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


