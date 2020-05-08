# Editor

```
,e               edit ~/.vimrc
,s               source ~/.vimrc
,l               toggle invisible characters
gx               open URL under cursor in web browser
```

Undo, Redo, Copy and Paste

```
u                undo last edit
U                undo line
<C-r>            redo last edit
y,Y              copy selection/line
p,P              paste after/below of before/above the cursor
```

Spelling 

```
,n               toggle line numbers
,d               toggle german spelling
,e               toggle english spelling
z=               list alternatives if word is incorrect
zG               add the word to the spelling file
:digraphs        list digraph characters
# add digraphs in insert mode
<C-k>=e          € (Euro)
<C-k>{a,o,u}:    äöü (German umlaut)
<C-k>{<<,>>}     «,»
<C-v><Esc>       Insert escape sequence ^[
```

Formatting

```
:retab           replace tabs with spaces
{gw}             reformat paragraph (using textwidth), keep cursor position
{gq}             reformat paragraph (using textwidth), move cursor
```

## Motions

```
[count]{hjkl}    left, down, up, right (default one char)
[count]{wW}      WORD/word forward (start of next word)
[count]{bB}      WORD/word backward (start of current/previous word)
[count]{eE}      WORD/word forward (end of current/next word)
[count]ge        WORD backward (end of previous word)
       0         first char in current line
       ^         first non-blank char in current line
       $         last char in current line
       g_        last non-blank char in current line
[count]+         first non-blank char of lines downward
[count]-         first non-blank char of lines upward
[count]G         first non-blank of line (default last line)
       1G, gg    got to start of file, aka first line
[count](         sentences backward
[count])         sentences forward
[count]{         paragraphs forward
[count]}         paragraphs backward
[count]gk        display line upwards
[count]gj        display line downwards
       <C-b>     scroll up
       <C-f>     scroll down
       <C-u>     scroll up 1/2 page
       <C-d>     scroll down 1/2 page
       zz        center cursor line
       zt        cursor line to the top
       zb        cursor line to the bottom
       %         go to corresponding (,{,[
```

## Search

```
,/                clear search highlighting
f{char}           forward search char
F{char}           backward search char
;                 repeat in same direction
,                 repeat in opposite direction
/pattern<CR>      forward search word
?pattern<CR>      backward search word 
n                 next match
N                 previous match
*                 next word under cursor
#                 previous word under cursor
```

Substitution

```
:s/pat/rpl/      first occurrence single line
:s/pat/rpl/g     all occurrences single line
:%s/pat/rpl/     first occurrence in file
:%s/pat/rpl/g    all occurrences in file
:%s/pat/rpl/gc   all occurrences in file with confirmation
```

## Insert & Replace

```
i                 insert text before the cursor
I                 insert text before first non-blank in line
a                 append text after the cursor
A                 append text at the end of the line
o                 begin a new line below the cursor and insert text
O                 begin a new line above the cursor and insert text
R                 replace mode (chars you type replace existing chars)
<Esc>,<C^[>       end insert or replace mode
```


## Delete

```
D                delete until end of line
[count]x         delete chars under and after cursor
[count]X         delete chars before cursor
[count]dd        delete lines
[count]J         join lines (delete line break)
d[count]w        delete words
d[count]b        delete words backward
dt{char}         delete forward until {char}
dT{char}         delete backward until {char} 
```

Delete before entering insert mode:

```
C                delete until end of line, and insert text
r{char}          replace char under cursor with {char}
[count]s         delete chars and insert text
[count]S         delete lines and insert text
c[count]w        delete words and insert text
```



## Folding

```
za               toggle folding
zc               close fold at the cursor
zo               open fold at the cursor
zR               open all folds
zM               close all open folds
zj               move cursor to next fold
zk               move cursor to previous fold
```


## Visual Mode

```
v                enter visual selection mode 
V                enter line selection mode 
y                copy selection into buffer
```

Column selection

```
<C-v>            enter column selection mode
I                insert in front of cursor (Esc to apply to all lines)
A                append after cursor
<C-r>"           paste from register
c                change selection (delete and switch to insert mode)
r                replace every character in selections
d                delete 
o                toggle cursor to opposite corner
```

