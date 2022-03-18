# location of the history file
export HISTFILE=~/.zsh_history
# number of commands that are loaded into memory
export HISTSIZE=100000
# number of commands that are stored 
export SAVEHIST=10000

# Sessions will append their history list to the history file, rather than
# replace it
setopt append_history

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups

setopt hist_verify

# This option both imports new commands from the history file, and also causes
# your typed commands to be appended to the history file
setopt share_history

# Ignore command with leading white-space
setopt hist_ignore_space


##
# Show the configuration of the shell history
#
zsh-history-config() { 
        printenv | grep HIST
        setopt kshoptionprint && setopt | grep hist | sort
}

zsh-history-erase() { 
        local HISTSIZE=0
        rm $HISTFILE
}
