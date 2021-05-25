
command -v sxiv >&- && {

        function sx() {
                sxiv -tp ${@:-$PWD}
        }

        # clean up cache in $HOME
        test -d ~/.cache/sxiv && rm -rf ~/.cache/sxiv

        function sxe() {
                sxiv -bo -pt $(
                        fd --type f '.*' $PWD \
                        | sort \
                        | fzf --exact \
                              --multi \
                              --bind 'ctrl-a:select-all+accept' \
                              --query "${@:-}"
                )
        }

} 
