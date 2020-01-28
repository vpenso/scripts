# Authorized Principles

> `AuthorizedPrincipalsFile` specifies a file that lists principal names that
> are accepted for certificate authentication.  When using certificates signed
> by a key listed in `TrustedUserCAKeys`, this file lists names, one of which
> must appear in the certificate for it to be accepted for authentication.

Configuration in `/etc/ssh/sshd_config`:

```
AuthorizedPrincipalsFile /etc/ssh/%u_principals
```

Accepts following **tokens**:

- `%%` a literal %
- `%h` home directory of the user
- `%u` user name

Names are listed one per line including key options like

```
# principle     # options
devops          command=/path/to/command,no-agent-forwarding,no-port-forwarding,no-pty
```

Cf. `AUTHORIZED_KEYS FILE FORMAT` in the `sshd_config.5` manual page.
