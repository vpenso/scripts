
command -v sxiv >&- && {

        function sx() {
                if [ -d "${@: -1}" ] || [ -h "${@: -1}" ]
                # if it is a directory
                then
                        # recursive search
                        # open with thumbnail mode
                        # enable private mode
                        sxiv -rbtp "$@"
                # it it is a single image
                else
                        # no info bar on the bottom
                        # enable private mode
                        sxiv -pb "$@"
                fi
        }

        # clean up cache in $HOME
        test -d ~/.cache/sxiv && rm -rf ~/.cache/sxiv

} 
