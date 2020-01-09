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

### Shells

Deploy the custom Zsh configuration in this repository with
[zsh-config](bin/zsh-config):

```bash
# customize Zsh configuration
zsh-config
```

* POSIX compatibility by loading `/etc/profile` in `/etc/zsh/zprofile`
* Write a minimal `~/.zshrc` to source scripts in `~/.zshrc.d`
* Copies Zsh customization from [etc/zshrc.d/](etc/zshrc.d) to `~/zshrc.d`

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
