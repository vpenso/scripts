# Control Structures

```bash
{a,b,c}        # brace expansion
{a..z}         # extened brace expansion 
if [ e1 ] ; then ; elif [ e2 ] ; then ; else ; fi
case e in ; c1) ;; c2 | c3) ;; *) ;; esac 
```

### Branches

Simple branching with the `if` statement:

```bash
if [[ $1 -eq 1 ]] ; then
        ...
elif [[ $1 -gt 2 ]] ; then
        ...
else
        ...
fi
```

* Closing `fi` is necessary, `elif` and `else` optional
* Always include spaces around `[[...]]` for command evaluation

Evaluate a mathematical expression:

```bash
if (( $1 + 1 > 2 )); then
        ...
fi
```

The `case` statement matches values against one variable:

* The argument to case is expanded and matched against patterns
* In case of a match run commands up to `;;`
* Patterns are not regular expressions byt shell pattern matching (aka globs)

```bash
case "$1" in
        1)
                echo $1
                ;;
        abc)
                echo def
                ;;
        2|3|4)
                echo num
                ;;
        *)
                echo no case
esac
```

### Loops

`for` loop using an iterator variable

```bash
for (( i = 0; i < 10; i++ ))
do
        echo $i
done
for (( i = 0, j = 0; i < 10; i++, j = i * i ))
do
        echo $i $j
done
```

Examples for `for..in..`

```bash
# brace expansion
for i in {1..10}; do 
	echo $i
done

# loop an array 
arr=(a b c d e f)
for i in "${arr[@]}";do
	echo $i
done
```

`while` loop:

```bash
i=0
while (( $i < 10 )) ;  do
        echo $i
        ((i++))
done

i=0
while [ $i -lt 10 ] ;  do
        echo $i
        i=$[$i+1]
done

# infinite loop
while true; do
	...
done
```

