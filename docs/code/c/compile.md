

# Compile

The **GCC** (GNU Compiler Collection) is one of the most widely used compilers for C programming language.

Simple C program `hello.c`:

```c
#include <stdio.h>      // header file including library functions

// Every program has to have a "main" function
int main(void)
{
   // print a string to standart output
   puts("Hello");
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

1. **Preprocessor**: Macro substitution, conditional compilation, include header files (output is still c)
2. **C Compiler**: Compile each C file into assembly language
3. **Assembler**: Assemble each file into object code.
4. **Linker**: Combine object files (including libraries) into program binary (executable image).

```bash
>>> gcc -save-temps -o hello hello.c && ls -1
hello                 # executable binary
hello.c               # source code
hello.i               # preprocessor output
hello.o               # object code
hello.s               # assembly code
# execute the program
>>> ./hello
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

