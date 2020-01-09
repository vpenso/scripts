## Line Editor - Vi Mode Configuration ##

# esc to switch to normal mode, i/a for insert/append
bindkey -v

# set delay after ESC to 0.1 second
export KEYTIMEOUT=1    

# preserver a couple of keys in insert mode
# (list widgets with `zle -la`, list keys with `bindkey`)

# make delete and backspace work
bindkey '^[[3~' delete-char
bindkey "^?" backward-delete-char
# ctrl-a/ctrl-e move cursor to beginning/end of the line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

# updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select

# represents the Vi mode indication  
function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/ NORMAL}/(main|viins)/ INSERT}"
}
