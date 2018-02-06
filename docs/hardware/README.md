

# Computer Architecture

An **instruction** is a single operation executed by a processor (defined by the processor **instruction set**)

**Control-flow architecture**:

Stored Program Computer (aka. Von Neumann Model)

* Stores instructions in memory (alongside data)
* Values in memory interpreted depending on the **control signal**
* Sequential instruction processing (fetch, execute, and complete) one at a time
* Current instruction identified by the **instruction pointer** (program counter)
* The instruction pointer is advanced sequentially except for control transfer
* Instructions executed in **control flow order**

**Data-flow architecture**:

* Instructions executed based on the availability of input arguments, **data flow order**
* Conceptually **no instruction pointer** required instruction ordering specified by data dependencies
* Inherently more parallel with the potential to execute many instructions at the same time 

Control- vs data-flow trade-offs:

* Ease of programming
* Ease of compilation
* Extraction of parallelism (performance)
* Hardware complexity

## Instruction Set Architecture

The Instruction Set Architecture (ISA) specifies how a programmer sees instructions to be executed:

* Defines an **interface between software and hardware** enabling the implementation of programs
* Modern ISAs are mostly control-flow architectures: x86, ARM, MIPS, SPARC, POWER
* ISAs have a very long lifetime (compared to µarch) staying backwards-compatible while being extended with additional instructions

The ISA includes all functionality exposed to the programmer:

* Instructions: Opcodes, addressing modes, data types, registers, condition code...
* Memory: Address space, alignment, virtual memory...
* Interrupt/exception handling, access control, priority/privileges
* Task/thread management, power & thermal management
* Multi-threading & multi-processing support

## Microarchitecture

The Microarchitecture (µarch) is the implementation of the ISA under specific design constrains and goals:

* The microprocessor is the physical representation (circuits) of the ISA and microarchitecture (µarch).
* Example: add instruction (ISA) vs adder implementation (µarch) [bit serial, ripple carry, carry lockahead, etc.]
* x86 ISA ha many implementations: Intel [2,3,4]86, Intel Pentium [Pro, 4], Intel Core, AMD...

The µarch defines anything done in hardware and can execute instructions in any order (e.g. data-flow order) as long it obeys the **semantics specified by the ISA**:

* Pipeline instruction execution (Intel 486)
* Multiple instructions at a time (Intel Pentium)
* Out-of-order execution (Intel Pentium Pro)
* Speculative execution
* Memory access scheduling policy
* Cache levels, size, associativity, replacement policy
* Separate instruction and data caches
* Superscalar processing
* Error correction
