



[Arch User Repository][aur] (AUR) (cf. [Arch User Guidelines][aug])

* Contains [package descriptions][pkg] `PKGBUILD` provided by the community
* Allows to build packages from source with `makepkg`

```bash
# install build tools
pacman -S --needed base-devel
```

Example:

```bash
# acquire build files
git clone https://aur.archlinux.org/ccrypt.git && cd ccrypt
# resolve dependencies, build the package, and install it
makepkg -si
```


[aur]: https://aur.archlinux.org/
[aug]: https://wiki.archlinux.org/index.php/Arch_User_Repository
[pkg]: https://wiki.archlinux.org/index.php/PKGBUILD
[aiv]: https://github.com/aur-archive
