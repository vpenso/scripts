### Delete

```
       D             delete until end of line
       C             delete until end of line, and insert text
[count]J             join lines (delete line break)
[count]x             delete chars under and after cursor
[count]X             delete chars before cursor
[count]s             delete chars and insert text
[count]S             delete lines and insert text
[count]r{char}       replace chars under and after cursor
       c[count]w     delete words and insert text
[count]dd            delete lines
       d0            delete to beginning of line
       d[count]w     delete words
       d[count]b     delete words backward
   :1,.d             delete to beginning of file
   :.,$d             delete untile end of file
       dt{char}      delete forward until {char}
       dT{char}      delete backward until {char}
``
