

# Computer Architecture

An **instruction** is a single operation executed by a processor (defined by the processor **instruction set**)

* Processors fetch instructions from memory
* Separation of processor and memory distinguishes programmable computers

**Control-flow architecture**:

Stored Program Computer

* **Von Neumann architecture**: Single memory holds data and instructions
  - Single set of address/data buses between processor and memory
  - Values in memory interpreted depending on a control signal
* **Harvard architecture**: Separate memory for data and instructions
  - Two sets of address/data buses between processor and memory
  - Allow simultaneous memory fetches
* **Modified Harvard architecture**: Separate memory for data and instructions
  - Instruction memory can be used to store data
  - Two pieces of data can be loaded in parallel
* Sequential instruction processing (fetch, execute, and complete) one at a time
* Current instruction identified by the **instruction pointer** (program counter)
* The instruction pointer is advanced sequentially except for control transfer
* Instructions executed in **control flow order**

**Data-flow architecture**:

* Instructions executed based on the availability of input arguments, **data flow order**
* Conceptually **no instruction pointer** required since execute based on data dependencies
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

**ISA Types**:

* Reduced Instruction Set Computer (RISC)
  - Compact, uniform instruction size ➜ easier to decode ➜ facilitates pipelines
  - Complexity implemented as series of smaller instructions
  - More lines of code ➜ bigger memory footprint
  - Allow effective compiler optimization
* Complex Instruction Set Computer (CISC)
  - Extremely specific instructions (doing as much work as possible)
  - Instructions not uniform in size ➜ difficult to decode
  - Pipelines requires break down of instructions into smaller components at processor level
  - High code density
  - Complex processor hardware
* Very long instruction word (VLIW)
  - Execute multiple instructions concurrently, in parallel
  - Instruction Level Parallelism (ILP)
  - Compiler bundles multiple instructions that can be executed in parallel into a single long instruction
  - 

## Microarchitecture

The Microarchitecture (µarch) is the implementation of the ISA under specific design constrains and goals:

* The microprocessor is the physical representation (circuits) of the ISA and µarch
* Example: add instruction (ISA) vs adder implementation (µarch) [bit serial, ripple carry, carry lockahead, etc.]
* Example: x86 ISA has many implementations - Intel [2,3,4]86, Intel Pentium [Pro, 4], Intel Core, AMD...
* Design points: cost, performance, power consumption, reliability, time to market...

The µarch defines anything done in hardware and can execute instructions in any order (e.g. data-flow order) as long it obeys the **semantics specified by the ISA**:

* Pipeline instruction execution (Intel 486)
* Multiple instructions at a time (Intel Pentium)
* Out-of-order execution (Intel Pentium Pro)
* Speculative execution, branch prediction, prefetching
* Memory access scheduling policy, cache (levels, size, associativity, replacement policy)
* Clock gating, dynamic voltage and frequency scaling (energy efficiency)
* Error handling, correction
* Superscalar processing, multiple instructions (VLIW architecture, Intel Itanium)
* SIMD processing (vector/array processors, GPUs)
* Systolic arrays (Google tensor-processor)

# Computer Data Storage

Programmers see **virtual memory** provided by the system (OS + hardware):

* Simplified abstraction of memory for the program providing the illusion of "infinite" memory
* The system manages the physical memory space transparent to the programmer by mapping virtual memory addresses to the limited physical memory
* Example for the programmer/(micro) architecture trade-off

Storage (physical memory) is divided into a **memory hierarchy**:

**Primary storage**:

- Processor **cache** is an intermediate stage between ultra-fast registers and much slower main memory 
- Volatile **main memory** (Random Access Memory (RAM)) operating at high speed compared to secondary strorage

**Secondary storage**:

- **Mass storage** devices like hard disk drives and rotating optical storage (CD/DVD)
- **Flash memory** like USB flash drives and solid-state drives (SSD)

## Technology

**Volatile memory** (DRAM vs SRAM):

* DRAM (Dynamic Random Access Memory): Capacitor charge state indicates stored value, cells lose charge over time requiring a refresh
  - Slower access (capacitor)
  - Higher density (cell: 1 transistor + 1 capacitor)
  - Lower cost
  - Requires refresh (power, performance, circuitry)
  - Manufacturing requires capacitors and logic
* SRAM (Static Random Access Memory): Two cross coupled inverters store a bit persistent (while powered)
  - Faster access (no capacitor)
  - Lower density (cell: 6 transistors)
  - Higher cost
  - No refresh needed
  - Manufacturing compatible with logic process

## Hierarchy

A memory hierarchy separates storage into a layers/levels based on **latency** (response time) and **capacity**:

* Fast and large storage can not be achieved with a single level memory
* Multiple levels of storage progressively bigger and slower

Typical modern memory(/cache) hierarchy:

Name      | Latency | Size
----------|---------|----------------
Register  | <1ns    | B
L1 cache  | ~1ns    | ~32KB
L2 cache  | >1ns    | <1MB
L3 cache  | >10ns   | >1MB
DRAM      | ~100ns  | GB
Swap      | ~10ms   | TB

## Cache

**CPU Cache** is used to avoid repeated access to main memory (typically DRAM):

* Automatically managed memory hierarchy (Level 1,2,3) (typically SRAM) 
* Stores frequently used data and is commonly on-die with an associated CPU 

**Locality** ensures that data required by the processor is kept in the fast(er) level(s):

* Idea: Store recently accessed and adjacent data automatically in fast memory (RAM and cache)
* Temporal locality is based on repetitive computations (e.g. loops) referencing the same memory
* Spatial locality is based on a probability of related computations referencing a cluster of memory (e.g. array)

Memory is logically divided into fixed-size **blocks**:

* Each block maps to a **location in the cache**, determined by the **index bits** in the address
* **Cache hit**: Use cached data instead if accessing next level memory
* **Cache miss**: Data not cached, read block from next level memory
* **Hit ratio**: percentage of accesses that result in cache hits
* **Average Memory Access Time** (AMAT): Metric to analyze memory system performance

### Associativity

Caches fall into three categories: 

* **Direct-mapped** 
  - Each memory location maps into one and only one cache block
  - Fast, simple, inefficient
  - Maximum cache misses
* **Fully associative**
  - Any memory location can map to anywhere in the cache
  - Slow, complex, efficient
  - Perfect replacement policy (no cache misses)
* N-way **set associative**
  - Groups of blocks "sets" from associative pools
  - A compromise between simplicity and efficiency
  - Reduces cache misses

Types of cache misses:

* **Compulsory** (start miss): First access to a block, must be brought into the cache
* **Capacity**: Blocks are being discarded to free space
* **Conflict** (collision/interference miss): Occurs when several memory locations are mapped to the same cache block 

**Replacement policy**: Heuristic used to select the entry to replaced by uncached data (LRU (Least Recently Used))

