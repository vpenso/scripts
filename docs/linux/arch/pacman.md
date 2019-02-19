

```bash
pacman -Sy                     # update package database
pacman -Ss <string>            # search package database       
pacman -Si <package>           # show information about package
pacman -S <name>               # install package
pacman -Suy                    # upgrade all packages
pacman -R <name>               # remove package
pactree <name>                 # list package dependencies
pacman -Fy                     # update file database
pacman -Fs <string>            # search package containing file
```

AUR (Arch User Repository)

<https://aur.archlinux.org/>

```bash
yaourt --stats                 # package stats
yaourt <string>                # search packages
yaourt -S <name>               # install package
yaourt -Syua                   # update all AUR packages 
```
