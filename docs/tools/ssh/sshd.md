
```bash
/etc/ssh/sshd_config       # configuration file
```

Diagnosing of connection problems running `sshd` in fore-ground:

```bash
$(which sshd) -dt           # check validity of the configuration file and keys
$(which sshd) -d            # run the server in debug mode
$(which sshd) -d -p 2222    # on a different port
```

Permanently enable debugging output:

```bash
echo 'LogLevel DEBUG3' >> /etc/ssh/sshd_config && \
        systemctl restart sshd
```


## Configuration

`LogLevel` specifies the level of verbosity for logging messages:

* Defaults to INFO
* Possible values: QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG2 and DEBUG3
