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
fzf-preview() {
        pager='cat {}'
        command -v bat >&- && \
                pager='bat --style=numbers --color=always --line-range :500 {}'
        fd --type f '.*' $SCRIPTS \
        | sort \
        | fzf --ansi \
              --exact \
              --preview "$pager" \
              --query ${1:-''}
}

alias f=fzf-preview

##
# Search all Markdown file in $SCRIPTS/docs and open with the Vim editor
#
fzf-edit() {
        ${EDITOR:-vim} $(fzf-preview $@)
}

alias fe=fzf-edit

