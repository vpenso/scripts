Modeline configures Vim settings embedded into the header of a file.

Enable modelines in your `vimrc`:

```
" enable modeline magic
set modeline
set modelines=5
```

Read `:help modeline` for more examples:

```
# vim: filetype=sh
/* vim: expandtap textwidth=80 tabstop=8 */
```

### References

Vim Wiki - Modeline magic  
<https://vim.fandom.com/wiki/Modeline_magic>

Vim/Neovim Arbitrary Code Execution via Modelines  
<https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md>

Vim Modeline Commands  
<https://github.com/inkarkat/vim-ModelineCommands>
