alias pw=password

# Use `password` on a remote node over SSH, and paste to local clipboard
#
# - Assumes a valid SSH configuration in ~/.ssh/ssh_config
# - Note: Second password prompt won't be visible
#
pwrp() { 
  ssh -t -F ~/.ssh/ssh_config instance "zsh -i -c 'password show $1'" | tail -n1 | tr -d '\n' | xclip -selection clipboard 
  # clear the clipboard
  (sleep 30; echo '' | xclip -selection clipboard) &
}
