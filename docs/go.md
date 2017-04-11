# Go Programming Language

Install Go language support:

```bash
apt -y -t jessie-backports install golang              # install build environment
```

`GOPATH` points to a **single common development workspace** for all go projects:

```bash
export GOPATH=~/project/go ; mkdir -p $GOPATH ; cd $GOPATH
export PATH=$PATH:$(go env GOPATH)/bin
go env GOPATH            # prints the effective current GOPATH
$GOPATH/src/             # source files in multiple VCS repos
go get                   # install dependencies into src/
$GOPATH/bin/             # executable commands
go install               # install binaries to bin/ or cache in pkg/ 
godoc -http=:6060        # access local documentation
```

Build and run a Go program:

```bash
>>> cat src/examples/hello.go       # simple hello world code
package main

func main() {
  println("Hello World")
}
>>> go run src/examples/hello.go    # compile and run code
Hello World
>>> go build src/examples/hello.go  # explicitly compile code
>>> ./hello                         # run the code 
Hello World
```

**Import Path** is a string that uniquely identifies a package:

- Corresponds to its location inside the workspace (or in a remote repository)
- For a canonical import path cf. [remote import path](https://golang.org/cmd/go/#hdr-Remote_import_paths)
- `src/$PROJECT/vendor/` directory contains dependency packages for specific project

I.e. an example project with import path `github.com/$USER/example/hello`

```
>>> mkdir -p src/github.com/$USER/example
>>> cat src/github.com/$USER/example/hello/hello.go 
package main
import "fmt"
func main() {
    fmt.Printf("Hello, world\n")
}
>>> go install src/github.com/vpenso/example/hello
>>> bin/hello 
Hello World
```

## Packages 

Reusable code is packaged as **shared library**:

* `package main` used for executable programs instead of a shared library
* `import` used to include a package into another package
* The compiler does not finish if an imported package is not used

```go
package p             // declare a package with name p
import "p"            // include a single package p
import (              // include a list of packages p,q
  "p" 
  "q" 
)
import (              // alias a,b for packages p,q 
  a "p"
  b "q" 
)
```

The compiler searches in `GOROOT/pkg` and `GOPATH/pkg`:

* Cf. Go [standard library](https://golang.org/pkg/#stdlib)
* Search for go packages in [GoDoc](https://godoc.org/)

```bash
$(go env GOROOT)/pkg/    # standard library     
$GOPATH/pkg/             # third-party packages
go list                  # list packages
go get <pkg>             # download/install third-party packages
```

## Variables

List of basic go **types**:

```
uint8                  0 to 255
uint16                 0 to 65535
uint32                 0 to 4294967295
uint64                 0 to 18446744073709551615
int8                   -128 to 127
int16                  -32768 to 32767
int32                  -2147483648 to 2147483647
int64                  -9223372036854775808 to 9223372036854775807
float32                IEEE-754 32-bit
float64                IEEE-754 64-bit
byte                   same as uint8
rune                   same as int32
bool                   false,true
string                 UTF-8-encoded text
```

List of basic **literls**:

```go
1                       // decimal
0123                    // octal
0x1a                    // hex
0X1A
0.                      // float
.25
1.2 
01.2
1e+0                    // scientific notation
1.234e-11 
1E6 
.123E+5
'c'                     // rune (character)
'\n'                    // escapes
'\''
"abc"                   // string
`abc`
"\n"
"\""
```

Variables can't be declared twice, `no new variables on left side of :=`

```go
var v T               // declare a new variable v of type T
v = V                 // assign a value V to declared variable v
var v T = x           // initalize a variable v of type T with x
v := V                // assign a value V by declareing a variable v using type inference
v := new(T)           // allocate a zeroed T value and return a pointer
```

Structures `struct` are typed collections of fields:

```go
type S struct {       // declare structure S with two fields F,G of type t,s
  F t
  G s
}
s = new(S)            // declare variable v of as instance of structure S
s := S{}              // initialize elements of S with zero
s := S{F: 1}          // G is initialized implicitly to zero
s := S{1,2}
s := &S{              // create instance and assign values
  F: v,
  G: w
}
s.F = 1               // access field f of structure
```

Slices are dynamically-sized arrays:

```go
[]T                              // slice with elements of type T
a := []T{e1,e2,..}               // slice a points to an array with elements e1,e2,... of type T
len(a)                           // length of slice a
a[i]                             // access element i of slice a
a[i:j]                           // access elements i to element j
a[i:]                            // access elements from i to len(a)
a[:j]                            // access elements from 0 to j
a := make([]T, l)                // create slice a with elements of type T with lenght l 
a := make([]T, l, c)             // same as above, with capacity c
for i, v := range a {}           // iterate over slice a, defining index i and value v 
for _, v := range a {}           // skip the index
for i := range a {}              // drop the value 
```

Maps

```go
m := make(map[T1]T2)              // create a map m with keys of type T1 and values of type T2
n := make(map[T]T{k: e,..})       // initialize map n with keys k and elements e
m[k] = v                          // assign value v to key k of map m
m[k]                              // access value of key k
len(m)                            // length of map m
delete(m,k)                       // remove key k of map m
_,p := m[k]                       // optional return value p insdicates presents of kay key in map m
if _,p := m[k]; p {}              // if key k is present in map m
```

## Functions

Cf. Go [build-in functions](https://golang.org/pkg/builtin/) i.e. `print`, `panic`

```go
func f(a,b T) R {}                // function f with arguments a,b of type T and return type R
func f(a T, b S) R {}             // individual types T,S for arguments a,b
func f(a T) r R {}                // name return value r of type R
func f() (T,R) { return x,y }     // mutliple return values x,y of type T,R
f := func(a T) R {}               // function value f with argument a of type T with return type R
func c() func(T) R {}             // function c returns closure with argument of type T and return type R
type C T                          // define type C of type T in your package
func (c C) f() R {}               // function f for type C
c := C(v) ; c.f                   // initialize type C with value v and call f()
func (c *C) g() R {}              // same as above but with a pointer to type C
c := &C{} ; c.g()                 // avoid copying the value
```

## Control Structures

```
if C { }                          // execute block if condition c evaluates to true
for { }                           // endless loop
for c { }                         // execute block as long as condition c is true
break                             // stop a loop
continue                          // skip to next loop itertion
switch v { case a: ; case f(): }  // evaluate from top to buttom, stopping on success
default:                          ///as default case
```

## Concurrency 

```go
go f(a,b,c)                       // light-weigth thread managed by go
c := make(chan T)                 // create channel c of type T
c := make(chan T, s)              // create channel c of type T with buffer size s
func f(a T, c chan R) {}          // function f() with second argument channel c of type R
c <- v                            // send value v to channel c
v := <-c                          // receive from channel c and assign to v
v,s := <-c                        // like above but indicates chancel state in s
for v := range c {}               // loop over channel c until it is closed
```


