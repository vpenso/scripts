# command-line fuzzy finder
# cf. https://github.com/junegunn/fzf
export FZF_DEFAULT_OPTS='--height 60% --border'

if [ "$shell" = "zsh" ]
then
        # key bindings and completion on Arch, Debian
        for file in /usr/share/fzf/key-bindings.zsh \
                    /usr/share/fzf/completion.zsh \
                    /usr/share/doc/fzf/examples/key-bindings.zsh \
                    /usr/share/zsh/vendor-completions/_fzf
        do
                [ -f $file ] && source $file
        done
fi

##
# Search all Markdown file in $SCRIPTS/docs and display with a pager
#
s() {
        file=$(fd --type f '.*' $SCRIPTS | sort | \
                        fzf --ansi --exact --query ${1:-''})
        command -v bat >&- && {
                bat --style=header,grid $file
                return
        }
        cat $file
}

##
# Search all Markdown file in $SCRIPTS/docs and open with the Vim editor
#
se() {
        file=$(fd --type f '.*' $SCRIPTS |\
                        fzf --ansi --exact --query ${1:-''})
        ${EDITOR:-vim} $file
}

