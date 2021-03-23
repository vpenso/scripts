File                       | Description
---------------------------|-----------------------------------
[var/cheat/vim.md][01]     | Custom Vim keybinding list
[etc/vimrc][03]            | Custom Vim configuration
[var/aliases/vim.sh][02]   | Vim environment configuration

[01]: ../../var/cheat/vim.md
[02]: ../../var/aliases/vim.sh
[03]: ../../etc/vimrc

## NeoVim

Install NeoVim, unless a recent version is available as distro package:

<https://github.com/neovim/neovim/releases>

```bash
# official AppImage
wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage -P ~/bin
chmod u+x ~/bin/nvim.appimage
ln -s ~/bin/nvim.appimage ~/bin/nvim
# install as Nix pacage
nix-env -i neovim
```

Install vim-plug [vplg]:

```bash
mkdir -p ~/.config/nvim/autoload
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Configuration:

File                   | Description
-----------------------|-------------------
`var/aliases/nvim.sh`  | Load NeoVim configuration from within this repository

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
