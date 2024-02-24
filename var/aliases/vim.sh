
# Vi is installed in close to all Linux environments by default
export EDITOR=vi
alias v=vi

# …if Vim is installed us it instead of classic Vi
command -v vim >/dev/null && {
        export EDITOR=vim
        alias v=vim
        alias v0='vim --clean'
}

# if NeoVim is installed by AppImage in home-directory
test -f $HOME/bin/nvim.appimage && alias nvim=nvim.appimage

# if NeoVim is installed
command -v nvim &>/dev/null && {
        export EDITOR=nvim
        alias nv=nvim
}

