

##
# Search all Markdown file in $SCRIPTS/docs and display with a pager
#
d() {
        file=$(fd --type f --color always '.md' $SCRIPTS |\
                        fzf --ansi --exact --query ${1:-''})
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
        file=$(fd --type f --color always '.md' $SCRIPTS |\
                        fzf --ansi --exact --query ${1:-''})
        vim $file
}
