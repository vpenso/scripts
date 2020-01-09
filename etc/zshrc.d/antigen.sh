# Install Zsh Antigen from GitHub
# https://github.com/zsh-users/antigen
if ! [ -f ~/.zsh/antigen.zsh ]
then

        mkdir ~/.zsh 2>/dev/null
        wget -q -O ~/.zsh/antigen.zsh \
                https://github.com/zsh-users/antigen/releases/download/v2.2.3/antigen.zsh
        echo Zsh Antigen installed to ~/.zsh/antigen.zsh
fi

if [ -f ~/.zsh/antigen.zsh ]
then
        ##
        ## Install plugins/bundels
        ##

        source ~/.zsh/antigen.zsh
        # list of bundles to install
        antigen bundle git
        antigen bundle zsh-users/zsh-completions           # https://github.com/zsh-users/zsh-completions
        antigen bundle zsh-users/zsh-autosuggestions       # https://github.com/zsh-users/zsh-autosuggestions
        antigen bundle zsh-users/zsh-syntax-highlighting   # https://github.com/zsh-users/zsh-syntax-highlighting
        antigen bundle olivierverdier/zsh-git-prompt
        # install packages
        antigen apply

        # https://github.com/zsh-users/antigen/wiki/Configuration

        ##
        ## Package configuration
        ##

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

        export ZSH_THEME_GIT_PROMPT_PREFIX="("
        export ZSH_THEME_GIT_PROMPT_SUFFIX=")"
        export ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
        export ZSH_THEME_GIT_PROMPT_CLEAN="✔"
        export ZSH_THEME_GIT_PROMPT_STAGED="%F{32}*"
        export ZSH_THEME_GIT_PROMPT_CONFLICTS="%F{32}X"
        export ZSH_THEME_GIT_PROMPT_CHANGED="%F{31}+"
        export ZSH_THEME_GIT_PROMPT_BRANCH="%F{243}"
        export ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{33}…"
        export ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
        export ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"

        export PROMPT=$'\n\e[32m%n\e[0m@\e[34m%m\e[0m:\e[31m%~\e[0m $(git_super_status) \n>>> '
fi
