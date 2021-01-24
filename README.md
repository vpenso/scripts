Use [source_me.sh](source_me.sh) to add aliases and scripts to the shell 
environment:

```bash
# load environment into this shell instance
source source_me.sh
```

* Set an environment variable `$SCRIPTS` with the absolute path to this directory
* Prepends `$SCRIPTS/bin` to the `$PATH` environment variable
* Sources all scripts in `var/aliases/*.sh`

## Structure

Path                               | Description
-----------------------------------|-----------------------------------
`bin/`                             | Scripts for various purposes
`docs/`                            | Notes on technologies
`etc/`                             | Configuration files
`src/`                             | Source code examples...
`src/arduino`                      | Everything for **Arduino** (MCU)
`src/raspberry_pi`                 | **Raspberry Pi** (SBC) coding...
`var/`                             | Stuff not fitting above
`var/aliases`                      | Helpful shell aliases
`var/bookmarks`                    | Collection of personal bookmarks
`var/circuits`                     | Some **electronics** toy projects


## License

Copyright 2012-2021 Victor Penso

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
