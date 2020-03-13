
```bash
/etc/ssh/sshd_config       # configuration file
```

## Debugging

Diagnosing of connection problems running `sshd` in fore-ground:

```bash
$(which sshd) -dt           # check validity of the configuration file and keys
$(which sshd) -d            # run the server in debug mode
$(which sshd) -d -p 2222    # on a different port
```

`LogLevel` specifies the level of verbosity for logging messages:

* Defaults to INFO
* Possible values: QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG2 and DEBUG3

```bash
echo 'LogLevel DEBUG3' >> /etc/ssh/sshd_config && \
        systemctl restart sshd
```

## Unprivileged

Run completely decoupled from the default system `sshd` configuration with a
given user account (not as root):

```bash
cd $(mktemp -d /tmp/sshd.XXXXXX)
ssh-keygen -t rsa -N '' -f ssh_host_rsa_key
cat > sshd_config <<EOF
UsePrivilegeSeparation no
HostKey $PWD/ssh_host_rsa_key
Port 2022
LogLevel DEBUG3
PidFile $PWD/sshd.pid
EOF
$(which sshd) -f sshd_config -dD
```

## ForceCommand

> Forces the execution of the command specified by ForceCommand, ignoring any
> command supplied by the client and `~/.ssh/rc` if present. The command is
> invoked by using the user's login shell with the -c option. This applies to
> shell, command, or subsystem execution. It is most useful inside a Match
> block. The command originally supplied by the client is available in the
> `SSH_ORIGINAL_COMMAND` environment variable. Specifying a command of
> internal-sftp will force the use of an in-process SFTP server that requires no
> support files when used with ChrootDirectory. The default is none.



