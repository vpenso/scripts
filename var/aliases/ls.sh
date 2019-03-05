alias ls='ls -Fh --color=always'   # default to classify, human readable sizes and colors
alias lS='ls -lS'                  # displays file size in order
alias l='ls -1'                    # only names, one per line
alias ll='ls -l'                   # long format
alias l.='ls -lA -d .*'            # only hidden files
alias cls='clear ; ls'
alias td='tree -d'                 # list only dirs 
alias t2='tree -L 2'               # max recursive depth of 2 levels
alias tu='tree -pfughF --du'       # permissions, user, group, sizes 

command -v exa >&- && {
        alias el='exa -l --git'
        alias eG='exa -lG --git'
        alias eT='exa -lT --git --group-directories-first -@ -L 2'
}

command -v lsd >&- && {
        alias l='lsd -1'
        alias lt='lsd --tree'
}
