File                       | Description
---------------------------|-----------------------------------
[bin/vim-cheat][01]        | Custom Vim keybinding list
[etc/vimrc][03]            | Custom Vim configuration
[var/aliases/vim.sh][02]   | Vim environment configuration


Positioning of a cursor in a line (motions), switch to insert mode:

```
0  ^    B       b  ge  H l    ew   E W      $     motions
|  |    |       |  |   |↓|    ||   | |      |
   word example-word    Example-word example.
   |                    ↑|                   |
   I                    ia                   A    insert mode
```

Combine motions with insert mode, i.e. `gea` append at the end of the previous
word.




[01]: ../../bin/vim-cheat
[02]: ../../var/aliases/vim.sh
[03]: ../../etc/vimrc

## References

[abov] A Byte of Vim  
https://vim.swaroopch.com/  
https://github.com/swaroopch/byte-of-vim  
http://koydl.in-berlin.de/vim/a_byte_of_vim_de.pdf (german)

[vitt] Vi IMproved – Vim: The Tutorial  
ftp://ftp.vim.org/pub/vim/doc/book/vimbook-OPL.pdf
