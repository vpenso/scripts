alias ssh-fast-encrypt='ssh -C4c arcfour,blowfish-cbc' # less secure but faster
alias ssh-snoop='tcpdump -lnn -i any port ssh and tcp-syn' # Spy on the SSH traffic
alias ssh-no-checks='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scp-no-checks='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Disable key based authentication...
alias ssh-no-keys='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
