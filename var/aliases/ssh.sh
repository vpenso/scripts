alias sr='ssh -l root'
alias rsync='rsync -avzrtp'  # Use archive mode by default

function ssh-tmux() {/usr/bin/ssh -A -t $@ "tmux attach || tmux new";}

alias ssh-fast-encrypt='ssh -C4c arcfour,blowfish-cbc' # less secure but faster
alias ssh-snoop='tcpdump -lnn -i any port ssh and tcp-syn' # Spy on the SSH traffic
alias ssh-no-checks='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scp-no-checks='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
# Generate key-pairs, use `-f <PATH>` to provide the location
alias ssh-keygen-ecdsa='ssh-keygen -t ecdsa -b 521 '
alias ssh-keygen-rsa='ssh-keygen -t rsa -b 4096'
alias ssh-keygen-no-password="ssh-keygen -q -t rsa -b 2048 -N ''"
