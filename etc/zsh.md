### Zsh

Deploy the custom Zsh configuration in this repository with
[zsh-config](bin/zsh-config):

```bash
# customize Zsh configuration
zsh-config
```

The above script will do following modifications to your system.

Make Zsh a **POSIX compliant shell** by loading `/etc/profile` (requires Sudo):

```bash
# cf. /etc/zsh/zprofile
emulate sh -c 'source /etc/profile'
```

This will load files from `/etc/profile.d/` also. However you need to start as a
login shell with `zsh -l`.

Writes a minimal `~/.zshrc` to **source files from `~/.zshrc.d`**:

```bash
if ! [ -z "$(ls -A ~/.zshrc.d)" ]
then
	for file in `\ls ~/.zshrc.d/*`
	do
  		source $file
	done
fi
```

The `~/.zshrc.d/` directory is used to enable drop-in configuration of Zsh. 

Copies custom Zsh configuration files from [etc/zshrc.d/](etc/zshrc.d) into
the `~/zshrc.d` directory.

```
# permanently load this repository into the environment
ln -sf $SCRIPTS/source_me.sh ~/.zshrc.d/scripts
```
