# path to cheat sheets within this repository
export SCRIPTS_CHEAT_PATH=$SCRIPTS/var/cheat

# search a cheat sheet, and display it
cheat() {
        bat --style=header,grid $(
                fd --type f '^[a-z]*' $SCRIPTS_CHEAT_PATH/ \
                | sort \
                | fzf --ansi --exact --query ${1:-''}
        )
}

alias c=cheat
