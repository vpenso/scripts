

##
# Search all Markdown file in $SCRIPTS/docs and display with a pager
#
d() {
        file=$(fd --type f --color always '.md' $SCRIPTS/docs | fzf --ansi)
        command -v bat >&- && {
                bat --style=plain $file
                return
        }
        cat $file
}

##
# Search all Markdown file in $SCRIPTS/docs and open with the Vim editor
#
dv() {
        vim $(fd --type f --color always '.md' $SCRIPTS/docs | fzf --ansi)
}
