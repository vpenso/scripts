
```shell
# single user installation
sudo mkdir /nix
sudo chown $USER:$USER /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source ~/.nix-profile/etc/profile.d/nix.sh
# unsinstall
rm -rf /nix
```

```shell
nix-env -qa 'name.*'      # list available packages
nix-env -i name           # install package
nix-env -e name           # un-install package
```


<https://nixos.org/manual/nix/stable/>
