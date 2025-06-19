# Vi is installed in close to all Linux environments by default
export EDITOR=vi
alias v=vi

# …if Vim is installed us it instead of classic Vi
command -v vim >/dev/null && {
  export EDITOR=vim
  alias v=vim
  alias v0='vim --clean'
}

# if NeoVim is installed
command -v nvim &>/dev/null && {

  # prefer NeoVim of classic Vim
  alias v=nvim
  export EDITOR=nvim

  # check for the NeoVim distributions
  test -d ~/.config/astronvim && {
    alias astronvim="NVIM_APPNAME=astronvim nvim"
    alias v=astronvim
    export EDITOR=astrovim
  }
}
