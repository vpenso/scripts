## ssh-agent-session

Usually users start an SSH agent the following way:

    » eval $(ssh-agent)
    Agent pid 2157
    » ssh-add ~/.ssh/id_rsa 
    Enter passphrase for /home/jdoe/.ssh/id_rsa:
    Identity added: /home/jdoe/.ssh/id_rsa (/home/jdoe/.ssh/id_rsa)
    » ssh-add -l 
    2048 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce .ssh/id_rsa (RSA)
    4096 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:cd project/id_rsa (RSA)

Keys are added with `ssh-add`. The script [ssh-agent-session][05] helps to use a single _ssh-agent_ session in multiple shells. 
It will start a new agent and store the connection information to `~/.ssh/agent-session`. 

    » source ssh-agent-session
    ssh-agent started, session in /home/jdoe/.ssh/agent-session
    » ssh-add ~/.ssh/id_rsa 
    […]

Another shell can bind to the same agent:

    » source ssh-agent-session
    ssh-agent running with process ID 19264
    » ssh-add -l 
    […]

It is convenient to source this script within the shell profile, in order to bind all shells to a single _ssh-agent_ instance.

    » echo "source /path/to/ssh-agent-session" >> ~/.zshrc

## ssh-fs

Install _sshfs_ on Debian (>= 7):

    » sudo apt-get install sshfs
    » sudo adduser $USER fuse
    » sudo tail -4 /etc/fuse.conf
    # Allow non-root users to specify the 'allow_other' or 'allow_root'
    # mount options.
    #
    user_allow_other
    » sudo /etc/init.d/udev restart

1. Install the `sshfs` package with APT.
2. Add your user account to the group _fuse_.
3. Uncomment `user_allow_other` in the file `/etc/fuse.conf`.
4. Restart the udev mapper.

Mount a directory from a remote host:

    » sshfs [user@]host[:port] /mnt/path -C -o reconnect,auto_cache,follow_symlinks
    » fusermount -u /mnt/pat

The script [ssh-fs][06] simplifies this process:

    » ssh-fs mount example.org:docs ~/docs
    » ssh-fs mount jdoe@example.org:/data /data
    » ssh-fs list 
    example.org:docs on /home/jdoe/docs
    example.org:/data on /data
    » ssh-fs umount /data
    » ssh-fs umount ~/docs

## ssh-instance

The script [ssh-instance][10] generates an `ssh_config` file used to address a specific host.


    » ssh-keygen -q -t rsa -b 2048 -N '' -f keys/id_rsa
    » ssh-instance -u root -i keys/id_rsa 10.1.1.26 
    […]
    » ssh -F ssh_config instance -C […]

 Other tools like [ssh-exec][11] or [ssh-sync][12] determine the target host by reading *ssh_config* by default.

    » ssh-exec 'mkdir -p -m 0700 ~/.ssh'
    » ssh-sync keys/id_rsa.pub :.ssh/authorized_keys
    […]


[05]: ../bin/ssh-agent-session
[06]: ../bin/ssh-fs
[10]: ../bin/ssh-instance
[11]: ../bin/ssh-exec
[12]: ../bin/ssh-sync
