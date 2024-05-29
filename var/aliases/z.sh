command -v zoxide >/dev/null && {
      # work-around to enable tab-completion
      function z () { 
              __zoxide_z "$@" 
      }
      eval "$(zoxide init zsh --no-cmd)"
}

