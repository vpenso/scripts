

```bash
pacman -Sy                     # update package database
pacman -Ss $string             # search package database       
pacman -Si $package            # show information about package
pacman -Q  $package            # check if package is installed
pacman -qg $package_group      # check if package group is installed
pacman -Ql $package            # list files from installed package
pacman -S $name                # install package
pacman -Suy                    # upgrade all packages
pacman -R $name                # remove package
pactree $name                  # list package dependencies
pacman -Fy                     # update file database
pacman -Fs $string             # search package containing file
```
