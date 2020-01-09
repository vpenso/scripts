## Description

* [bin/](bin/) – Scripts for various purposes...
* [docs/](docs/) – Notes about IT technologies... 
* [etc/](etc/) – Configuration files...

Use [source_me.sh](source_me.sh) to add aliases and scripts to the shell 
environment:

```bash
# load environment into this shell instance
source source_me.sh
```

* Set an environment variable `$SCRIPTS` with the absolute path to this directory
* Prepends `$SCRIPTS/bin` to the `$PATH` environment variable
* Sources all scripts in `var/aliases/*.sh`

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

This will load files from `/etc/profile.d/` also.

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

## License

Copyright 2012-2020 Victor Penso

This is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. If not, see 
<http://www.gnu.org/licenses/>.
