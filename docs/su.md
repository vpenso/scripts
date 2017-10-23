## Su

`su` command stands for "switch user", and requires the password of the account to be used.

```bash
su                         # switch to root user
su <user>                  # switch to a specific user
su - ...                   # invoke a login shell for another user
su -p ...                  # preserve caller environment variables
su - -c '<command>' <user> # execute a command as different user
gksu -u <user> <app>       # start a GUI application
```

### Example

Start X applications as another user:

```bash
>>> xhost +                  # grant users access to your display
>>> su - <user>              # switch user sourcing profiles
## after login as another user
>>> export DISPLAY=:0.0      # export DISPLAY environment variable
```

## Sudo

`sudo` allows to execute a command on behalf of another users without requiring the password.

```bash
/etc/sudoers               # main configuration file for policies
/etc/sudoers.d/*           # additional configuration files    
sudo -ll                   # show user sudo configuration
sudo -lU <user>            # show configuration for another user
sudo su - <user>           # invoke a login shell as user
sudo -i <user>             # ^^
sudo -s <user>             # executes $SHELL as user
sudo -E <command>          # preserver environment variables (no shell functions)
```

### Configuration

Basic policy:

```bash
# comment a policy
<user> <host>[,<host>,...] = (<user>[,<user>,...]:<group>[.<group>,...]) [NOPASSWD:] <command>[,<command>,...]
```

Aliases:

```bash
# list of one or more hostnames, IP addresses, network numbers or netgroups
Host_Alias <NAME> = <ip>,[<ip>,...][,<hostname>[,<hostname>,...]
Host_Alias <NETWORK> = <ip>/<mask>
# alias is list of one or more users, groups, uids etc.
User_Alias <USERS> = <user>[,...][,%<group>,...], 
# list of commandnames, files or directories
Cmnd_Alias <COMMAND> = <command][,<command>,...]
```

### Examples

```bash
vpenso ALL=(ALL) ALL       # user vpenso gains root priviliges
%wheel ALL=(ALL) ALL       # group wheel gains root priviliges
# user vpenso can execute apt as root
vpenso ALL = (root) /usr/bin/apt
# host shutdown
Cmnd_Alias POWER = /bin/systemctl poweroff
# allow password changes with the exception of root
Cmnd_Alias PASSWD = /usr/bin/passwd [A-z]*, !/usr/bin/passwd root
# vpenso can execute defined by command aliases
vpenso localhost = (root) NOPASSWD: POWER,PASSWD
```

