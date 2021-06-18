
# delete default configuration if it exists
[ -f ~/.dir_colors ] && rm ~/.dir_colors
# read the configuration from this repository
eval "$(dircolors -b $SCRIPTS/etc/dir_colors/rainbow)"

alias ls='ls -Fh --color=always'   # default to classify, human readable sizes and colors
alias lS='ls -lS'                  # displays file size in order
alias l='ls -1'                    # only names, one per line
alias ll='ls -l'                   # long format
alias l.='ls -lA -d .*'            # only hidden files
alias cls='clear ; ls'             # clear shell and exec ls
alias td='tree -d'                 # list only directories
alias t2='tree -L 2'               # max recursive depth of 2 levels
alias tu='tree -pfughF --du'       # permissions, user, group, sizes 

# if the exa command is installed
command -v exa >&- && {
        alias l='exa -1'
        alias ls='exa -F'
        alias ll='exa -alF'
        alias eT='exa -lT --git --group-directories-first -@ -L 2'
}

# if the `lsd` command is installed
command -v lsd >&- && {
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
