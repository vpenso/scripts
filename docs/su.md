## Su

`su` command stands for "switch user", and requires the password of the account to be used.

```bash
su                         # switch to root user
su <user>                  # switch to a specific user
su - ...                   # invoke a login shell for another user
su -p ...                  # preserve caller environment variables
su - -c '<command>' <user> # execute a command as different user
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
```

Configuration examples:

```bash
vpenso ALL=(ALL) ALL       # user vpenso gains root priviliges
%wheel ALL=(ALL) ALL       # group wheel gains root priviliges
# user vpenso can execute apt as root without password
vpenso ALL=(root) NOPASSWD: /usr/bin/apt
```

