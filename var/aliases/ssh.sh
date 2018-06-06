# install require package on ArchLinux bases distributions
if [ -f /usr/sbin/pacman ]
then
	if ! [[ \
		-f /usr/bin/sshfs && \
		-f /usr/bin/sshuttle && \
		-f /usr/bin/rsync && \
		-f /usr/bin/tcpdump
	     ]]
	then
		sudo pacman -Sy --noconfirm sshfs sshuttle rsync tcpdump
	fi
fi

alias sr='ssh -l root'
      shuttle() { sshuttle -r --dns $1 0/0 ; } # Launch SSH proxy
alias rsync='rsync -avzrtp'  # Use archive mode by default
alias ssh-fast-encrypt='ssh -C4c arcfour,blowfish-cbc' # less secure but faster
alias ssh-snoop='tcpdump -lnn -i any port ssh and tcp-syn' # Spy on the SSH traffic
alias ssh-no-checks='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias scp-no-checks='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
# Generate key-pairs, use `-f <PATH>` to provide the location
alias ssh-keygen-ecdsa='ssh-keygen -t ecdsa -b 521 '
alias ssh-keygen-rsa='ssh-keygen -t rsa -b 4096'
alias ssh-keygen-no-password="ssh-keygen -q -t rsa -b 2048 -N ''"
