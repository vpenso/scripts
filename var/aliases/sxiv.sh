
command -v sxiv >&- && {

        function sx() {
                sxiv -tp ${@:-$PWD}
        }

        # clean up cache in $HOME
        test -d ~/.cache/sxiv && rm -rf ~/.cache/sxiv

} 
