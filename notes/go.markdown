
    ;                                 terminate statement (mostly automatically added by the lexer)
    //                                line comment
    /* */                             block comment
    var v T                           new variable of type T
    v := new(T)                       allocate a zeroed T value and return a pointer

## Control Structures

    if C { }                          execute block if condition c evaluates to true    
    for { }                           endless loop
    for c { }                         execute block as long as condition c is true
    switch v { case a: ; case f(): }  evaluate from top to buttom, stopping on success
    default:                          as default case
    fallthrouh                        prevent automaticall break


## Structures

    type S struct { f T; g S }       structure S with two fields f,g of type T,S
    s := S{}                         initialize elements of S with zero  
    s := S{f1: 1}                    f2 is initialized implicitly to zero
    s := S{1,2}
    s.f1 = 1                         access field f1 of structure s  

## Slices

    []T                              slice with elements of type T
    a := []T{e1,e2,..}               slice a points to an array with elements e1,e2,... of type T
    len(a)                           length of slice a
    a[i]                             access element i of slice a
    a[i:j]                           access elements i to element j
    a[i:]                            access elements from i to len(a)
    a[:j]                            access elements from 0 to j
    a := make([]T, l)                create slice a with elements of type T with lenght l 
    a := make([]T, l, c)             same as above, with capacity c
    for i, v := range a {}           iterate over slice a, defining index i and value v 
    for _, v := range a {}           skip the index
    for i := range a {}              drop the value 

## Maps

    m := make(map[T1]T2)              create a map m with keys of type T1 and values of type T2
    n := make(map[T]T{k: e,..})       initialize map n with keys k and elements e     
    m[k] = v                          assign value v to key k of map m
    m[k]                              access value of key k
    len(m)                            length of map m
    delete(m,k)                       remove key k of map m
    _,p := m[k]                       optional return value p insdicates presents of kay key in map m
    if _,p := m[k]; p {}              if key k is present in map m           

## Functions

    func f(a,b T) R {}                function f with arguments a,b of type T and return type R
    func f(a T, b S) R {}             individual types T,S for arguments a,b
    func f(a T) r R {}                name return value r of type R
    func f() (T,R) { return x,y }     mutliple return values x,y of type T,R
    f := func(a T) R {}               function value f with argument a of type T with return type R
    func c() func(T) R {}             function c returns closure with argument of type T and return type R
    type C T                          define type C of type T in your package
    func (c C) f() R {}               function f for type C
    c := C(v) ; c.f                   initialize type C with value v and call f()                   
    func (c *C) g() R {}              same as above but with a pointer to type C        
    c := &C{} ; c.g()                 avoid copying the value

## Concurrency 

    go f(a,b,c)                       lightweigth thread managed by go
    c := make(chan T)                 create channel c of type T
    c := make(chan T, s)              create channel c of type T with buffer size s
    func f(a T, c chan R) {}          function f() with second argument channel c of type R
    c <- v                            send value v to channel c
    v := <-c                          receive from channel c and assign to v
    v,s := <-c                        like above but indicates chancel state in s
    for v := range c {}               loop over channel c until it is closed



