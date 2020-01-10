export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=251'

# Configure command line syntax highlighting
# https://github.com/zsh-users/zsh-syntax-highlightin
case $ZSH_VERSION in
5\.0*) 
        # that is to old
        ;;
*)
        export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
        # parameter assignments (x=foo and x=( ))
        export ZSH_HIGHLIGHT_STYLES[assign]='fg=52'
        export ZSH_HIGHLIGHT_STYLES[comment]='fg=250'
        export ZSH_HIGHLIGHT_STYLES[command]='fg=27'
        export ZSH_HIGHLIGHT_STYLES[builtin]='fg=27'
        export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=27'
        export ZSH_HIGHLIGHT_STYLES[precommand]='fg=27'
        # single-hyphen options (-o)
        export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=54'
        # double-hyphen options (--option)
        export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=54'
        export ZSH_HIGHLIGHT_STYLES[function]='fg=29'
        export ZSH_HIGHLIGHT_STYLES[alias]='fg=29'
        export ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=29'
        # command separation tokens (;, &&)
        export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=166,bold'
        # redirection operators (<, >, etc)
        export ZSH_HIGHLIGHT_STYLES[redirection]='fg=166,bold'
        # single-quoted arguments ('foo')
        export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=110'
        # double-quoted arguments ("foo")
        export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=110'
        # parameter expansion inside double quotes ($foo inside "")
        export ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=19'
        # dollar-quoted arguments ($'foo')
        export ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=19'
        ;;
esac
