## Login Management

```bash
systemctl status systemd-logind.service         # state of the login manager
man logind.conf                                 # login manager configuration
```

`pam_systemd` registers user sessions with the systemd login manager

```bash
apt install libpam-systemd                      # install PAM support for systemd
grep pam_systemd.so /etc/pam.d/*                # PAM configuration for systemd
systemctl status dbus.service                   # DBus is required by pam_systemd.so
```
All user sessions `session-<id>.scope` of belong to a slice `user-<uid>.slice` below the `user.slice`

```bash
loginctl [list-users]                           # list users
loginctl user-status <user>                     # show run-time information of user
loginctl terminate-user <user>                  # terminate all user sessions
loginctl list-seats                             # list seats
loginctl seat-status <seat>                     # list devices associated to seat
ls ~<user>/.config/systemd/user                 # unit files for a given user
loginctl enable-linger <user>                   # make user sessions (boot) persistant    
```
