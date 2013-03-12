#
# Copyright 2013 Victor Penso
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

alias scp="noglob scp"

# Use archive mode by default
alias rsync='rsync -avzrtp'

# Remote login as root
alias rssh='ssh -l root'

# less secure but faster
alias fssh='ssh -C4c arcfour,blowfish-cbc'

# Agent forwarding
alias ssha='ssh -A'

# Spy on the SSH traffic
alias sshdump='tcpdump -lnn -i any port ssh and tcp-syn'

# Compression by default for remote mounts
alias sshfs='sshfs -C'

# Generate key-pairs, use `-f <PATH>` to provide the location
alias ssh-keygen-ecdsa="ssh-keygen -t ecdsa -b 521 "
alias ssh-keygen-rsa='ssh-keygen -t rsa -b 4096'
alias ssh-keygen-no-password="ssh-keygen -q -t rsa -b 2048 -N ''"

# Launch SSH proxy
function shuttle() { sshuttle -r --dns $1 0/0 }
