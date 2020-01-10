# Zsh

Install the Zsh configuration from this repository using the following script:

```bash
$SCRIPTS/bin/zsh-config     # requires Sudo
```

## POSIX Compliance

Following line will be added to `/etc/zsh/zprofile` to make sure the Zsh login
shells source `/etc/profile`:

```bash
emulate sh -c 'source /etc/profile'
```

POSIX compliant shell are required to load this file, which enables to **share
generic configurations with other shell variants**. Typically it loads files
from `/etc/profile.d/` when the shell gets initialized.

However you need to start as a login shell with `zsh -l`.

Any global configuration should be added to `/etc/profile.d/`, in order to be
available to all shells.

## Drop-in Configuration Directory

A very minimal `~/.zshrc` is created which **source files from `~/.zshrc.d/`**:

```bash
if ! [ -z "$(ls -A ~/.zshrc.d)" ]
then
	for file in `\ls ~/.zshrc.d/*`
	do
  		source $file
	done
fi
```

The `~/.zshrc.d/` can be used to drop-in additional Zsh specific customization.

Configuration files `*.sh` within this directory will be copied to the
`~/zshrc.d`.

```bash
# permanently load this repository into the environment
ln -sf $SCRIPTS/source_me.sh ~/.zshrc.d/scripts
```


