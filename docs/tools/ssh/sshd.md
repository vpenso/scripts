
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
