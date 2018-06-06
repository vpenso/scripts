export HISTSIZE=100000                       # set history size
export SAVEHIST=$HISTSIZE                    # save history after logout
export HISTCONTROL=ignoreboth                # [BASH] ignore entries with leading white space and dupes.

if [[ "$SHELL" == *"zsh" ]]
then
	setopt append_history                        # append into history file
	setopt inc_append_history                    # save every command before it is executed
	setopt extended_history                      # add time stamp for each entry
	setopt hist_expire_dups_first
	setopt hist_ignore_dups                      # ignore duplication command history list
	setopt hist_ignore_space                     # ignore command lines with leading space
	setopt hist_verify                           # show expanded history before running it
	setopt share_history                         # share command history data

	alias '?'='fc -li 1'                         # list history with time stamp
        alias '?5'='history -5'                      # list last five entries in history
fi

