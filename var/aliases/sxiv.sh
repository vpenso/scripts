
command -v sxiv >&- && {

        function sx() {
                sxiv -o -b -tp ${@:-$PWD}
        }

        # clean up cache in $HOME
        test -d ~/.cache/sxiv && rm -rf ~/.cache/sxiv

        function sxe() {
                sxiv -o -pt $@ $(
                        fd --type f '.*' $PWD \
                        | sort \
                        | fzf --exact \
                              --multi \
                              --bind 'ctrl-a:select-all+accept' \
                              --query "${@:-}"
                )
        }

        function sxi() {
                local file=${1:?Path to file missing}
                cat $file | sxiv -i -t -b -p
        }

} 
