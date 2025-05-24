command -v tmux >/dev/null && {
  # install tmux plugin manager...
  test -d ~/.tmux/plugins/tpm ||
    git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # link to the configuration within this repository
  test -L ~/.tmux.conf ||
    ln -s $SCRIPTS/etc/tmux/tmux.conf ~/.tmux.conf

  alias t=tmux
}
