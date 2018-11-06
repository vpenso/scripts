
```bash
# mark line as comment
;              # statement (command) separator
a[i]=v         # store value v as element i in array a
{c;}           # block of code anonymous subroutine
f() {c;}       # named subroutine (key-word `function` optional)
a=(e1 e2 ...)  # assign list of elements e1,e2,... to variable a
${a[i]}        # use element i from array a
${a}           # use element 0 from array a
${a[*]}        # use all elements from array a
${#a[*]}       # length of array a
```

