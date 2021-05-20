
command -v sxiv >&- && {

        function sx() {
                sxiv -tp ${@:-$PWD}
        }

        # clean up cache in $HOME
        test -d ~/.cache/sxiv && rm -rf ~/.cache/sxiv

        function sxe() {
                sxiv -pt $(
                        fd --type f '.*' $PWD \
                        | sort \
                        | fzf -e -m --bind 'ctrl-a:select-all+accept'
                )
        }

} 
