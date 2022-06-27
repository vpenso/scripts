
# delete default configuration if it exists
[ -f ~/.dir_colors ] && rm ~/.dir_colors
# read the configuration from this repository
eval "$(dircolors -b $SCRIPTS/etc/dir_colors/rainbow)"

alias ls='ls -Fh --color=always'   # default to classify, human readable sizes and colors
alias l='ls -1'                    # only names, one per line
alias ll='ls -l'                   # long format
alias lS='ls -lS'                  # displays file size in order

command -v tree >/dev/null && {
        alias td='tree -d'                 # list only directories
        alias t2='tree -L 2'               # max recursive depth of 2 levels
        alias tu='tree -pfughF --du'       # permissions, user, group, sizes
}

command -v exa >/dev/null && {

        # Specifies the number of spaces to print between an icon and its file name
        export EXA_ICON_SPACING=2
        alias ls="exa -F --icons"
        alias l='exa -1 --icons'
        alias ll='exa -alF --icons'
        alias lt='exa --tree --level=2 --icons' 
}

command -v lsd >/dev/null && {
        alias ls=lsd
        alias l='lsd -1F --group-dirs=first'
        alias l.='lsd -1 --all --group-dirs=first'
        alias lt='lsd -F --tree'
}

function dir-files() {
        # recursive find all directories
        for d in $(find . -maxdepth 5 -type d)
        do
                # count number of files in the directory
                echo -n $(find $d -type f | wc -l)
                echo ' '${d/\.\//}
        done
}
