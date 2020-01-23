
## SSH Agent

The `ssh-agent` is used for SSH public key authentication:

* **Keeps track of user's identity keys and their passphrases**
* Many Linux distributions automatically start an ssh-agent on login
* Keys are added to an running ssh-agent with `ssh-add`

Start an SSH agent the following way:

```bash
>>> eval $(ssh-agent)
Agent pid 2157
# load an private key into the agent
>>> ssh-add ~/.ssh/id_rsa 
Enter passphrase for /home/jdow/.ssh/id_rsa:
Identity added: /home/jdow/.ssh/id_rsa (/home/jdoe/.ssh/id_rsa)
# list loaded private keys
>>> ssh-add -l 
2048 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:ce .ssh/id_rsa (RSA)
4096 2b:c5:77:23:c1:34:ab:23:79:e6:34:71:7a:65:70:cd project/id_rsa (RSA)
```


The script ↴ [ssh-agent-session][05] helps to use a **single SSH agent session in multiple shells**.

It will start a new agent and store the connection information to `~/.ssh/agent-session`. 

```bash
>>> source ssh-agent-session
ssh-agent started, session in /home/jdow/.ssh/agent-session
>>> ssh-add ~/.ssh/id_rsa 
[…]
```

Another shell can bind to the same agent:

```bash
>>> source ssh-agent-session
ssh-agent running with process ID 19264
>>> ssh-add -l 
[…]
```

It is convenient to source this script within the shell profile, in order to bind all shells to a single _ssh-agent_ instance.

```bash
echo "source /path/to/ssh-agent-session" >> ~/.zshrc
```

[05]: ../../../bin/ssh-agent-session

