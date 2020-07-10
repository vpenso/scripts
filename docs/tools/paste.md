Display to inputs side by side
```bash
>>> paste <(echo 'a\nb\nc') <(echo '1\n2\n3')       
a	1
b	2
c	3
# custom a delimiter 
>>> paste -d'-' <(echo 'a\nb\nc') <(echo '1\n2\n3')
a-1
b-2
c-3
# three inputs with custom delimiter
>>> paste -d'%|' <(echo 'a\nb\nc') <(echo '1\n2\n3') <(echo 'x\ny\nz')
a%1|x
b%2|y
c%3|z
```

Serialize multiple lines

```bash
# tab as default delimiter
>>> echo 'a\nb\nc' | paste -s
a	b	c
# custom delimiter
>>> echo 'a\nb\nc' | paste -s -d'-'
a-b-c
```
