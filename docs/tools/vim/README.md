File                       | Description
---------------------------|-----------------------------------
[bin/vim-cheat][01]        | Custom Vim keybinding list
[etc/vimrc][03]            | Custom Vim configuration
[var/aliases/vim.sh][02]   | Vim environment configuration

[01]: ../../bin/vim-cheat
[02]: ../../var/aliases/vim.sh
[03]: ../../etc/vimrc

## Install

### NeoVim

<https://github.com/neovim/neovim/releases>

```bash
wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage -P ~/bin
chmod u+x ~/bin/nvim.appimage
ln -s ~/bin/nvim.appimage ~/bin/nvim
mkdir -p ~/.config/nvim/autoload
# install vim-plug [vplg]
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# install configuration file
ln -s $SCRIPTS/etc/nvim/init.vim ~/.config/nvim/init.vim
```

## References

[abov] A Byte of Vim  
<https://vim.swaroopch.com/>  
<https://github.com/swaroopch/byte-of-vim>  
<http://koydl.in-berlin.de/vim/a_byte_of_vim_de.pdf> (German)

[nvim] NeoVim  
<https://neovim.io/>  
<https://github.com/neovim/neovim>

[svim] SpaceVim  
<https://spacevim.org/>  
<https://github.com/SpaceVim/SpaceVim>

[vitt] Vi IMproved – Vim: The Tutorial  
<ftp://ftp.vim.org/pub/vim/doc/book/vimbook-OPL.pdf>

[vplg] vim-plug: A minimalist Vim plugin manager  
<https://github.com/junegunn/vim-plug>
