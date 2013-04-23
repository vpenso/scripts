

## Connection from a Public place

**[Sshuttle][10] enable access to a remote network over SSH.**
Technically it is part transparent proxy, part Virtual Private
Network (VPN), and part SSH forwarding. Since it is based on 
SSH, traffic is encrypted, and it is installed on the client 
side only. Basically if SSH access to a remote network is 
available, _sshuttle_ can hook the client into the remote network.

On Debian Wheezy install shuttle with:

    » sudo apt-get install sshuttle

The basic command to connect with the remote network is (first
the Sudo password is prompted, next the SSH login password):

    » sshuttle --dns --remote [user@]host[:port] --daemon --pidfile=/tmp/sshuttle.pid 0/0  

This will route all your traffic (including DNS requests) 
transparently through SSH. Shutdown _sshuttle_ with:

    » kill $(cat /tmp/sshuttle.pid)

If the client is connected via _sshuttle_ it appears to be 
inside the remote network. It can connect to all resource 
available only internal in the remote network. Using this
method to connect to a cooperate network, implies that all
outgoing traffic from the login node _sshuttle_ is connected 
to can be monitored.

It is possible to define aliases for convenient use of 
_sshuttle_, or alternatively us the wrapper script [`ssh-tunnel`][11].

    » ssh-tunnel connect jdoe@example.org
    [local sudo] Password: 
    jdoe@example.org's password: 
    Connected.
    [...SNIP...]
    » ssh-tunnel status
    Sshuttle running with PID 15083.
    » ssh-tunnel disconnect
    » ssh-tunnel status
    Sshuttle not connected.


[10]: https://github.com/apenwarr/sshuttle
[11]: ../bin/ssh-tunnel

