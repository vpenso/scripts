
# Linux Libraries

Executables contain binary code and data directly loaded to 
memory before execution. Libraries (relocatable objects) contain
binary code and data used by multiple executables. For example
the "libc" contains all C library functions like `printf` or 
`fopen` used by most programs. 

Conventionally libraries have names like `lib{name}.{a,so}`, 
where static libraries use the suffix `.a` (archive) and 
dynamically linked libraries the suffix `.so` (shared object).

**Compatibility**: Usually it is save to load a library with
the same major version number, since minor numbers indicate 
bug fixes.

Examine libraries with tools from the _binutils_ package.
The **symbol table** (inside each shared object file) maps 
objects to names the linker can understand.

    nm -D file            print symbol table of library
    objdump -T file       print dynamic symbol table
    readelf -d file       print dynamic section of ELF binaries 
                          (like objdump -x)

## Static Libraries

Static libraries are bind into an executable at compile time.
This increases the size of the resulting binary since the 
library objects get copied, but therefore the program is
independent from externals.

Create a static library `libxyz.a` from three object files x, y and z:

    » gcc -c x.c -o x.o
    [...SNIP...]
    » ar rcs libxyz.a x.o y.o z.o
    » ar -t libxyz.a
    [...SNIP...]

Compile an executable e using static library `libxyz.a`:

    » gcc -static e.c -L. -lxyz -o e

Static libraries are beneficial for small programs. Programs
depending on multiple libraries should use shared libraries
to reduce the run-time memory footprint. 

## Shared Libraries

Shared libraries can be used by multiple programs simultaneously,
hence only a single copy is needed in memory. Linux supports 
two ways of using shared libraries:

- **Dynamic Linking** loads a library on execution (unless its 
in memory already).
- **Dynamic Loading** (DL) selectively loads library functions during 
run-time. The DL API functions are `dlopen`, `dlsym`, `dlerror`, and
`dlclose` (include `dlfcn.h`).

Locations of shared libraries are defined in `/etc/ld.so.conf`,
and used by `ldconfig` to create run-time bindings dynamically.

    ldconfig              create run-time bindings chache
    ldconfig -p           prints the bindings cache
    ldconfig -n path      adds path to bindings cache (temporarily)

Add custom library paths to `/etc/ld.so.conf.d/`. 

    $LD_LIBRARY_PATH      adjust te library paths 
    $LD_PRELOAD           selectifly overwrite system libraries

Useful tools to debug library dependencies:

    ldd f                 list shared librarys used by file f

Compile an executable e with dynamic loading of library `libxyz`:

    » gcc -rdynamic -L. -lxyz -o e e.c


