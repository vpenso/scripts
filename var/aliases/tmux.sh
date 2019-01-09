# link the configuration within this repository to the home-directory
ln -sf $SCRIPTS/etc/tmux.conf ~/.tmux.conf

# couple of useful aliases...
alias t=tmux
alias tl="tmux list-sessions"
alias ta="tmux attach-session"
