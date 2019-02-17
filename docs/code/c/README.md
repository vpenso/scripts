# C Programming Language

**High-level language** (in contrast to low-level assembly language):

- Gives **symbolic names** to values (no need to know registers and memory locations)
- **Abstraction of underlying hardware** (operators do not depend on instruction set (ISA))
- Provides expressiveness, meaningful symbols, **expressions** and **control patterns** (i.e. if-else)
- Enhances code readability, **enforces rules** at compile-time

Building blocks of the C programming language:

* Variables
* Operators
* Expressions
* Statements & Statement Blocks (control structures)
* Function Blocks

The **compiler** translates the programming language to machine code (executable program):

* Source code analysis (front-end)
  - **Parses** the program to identify its pieces (i.e. variables, expressions, etc.)
  - Depends on language not the target machine architecture
* Code generation (back-end)
  - Generates **machine code** from analyzed source
  - Optimizes machine code to run more efficient on target hardware
  - Highly dependent on target machine architecture
* Symbol table - Maps between symbolic names and items


