# Nix

```shell
# single user installation
sudo mkdir /nix
sudo chown $USER:$USER /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source ~/.nix-profile/etc/profile.d/nix.sh
# unsinstall
rm -rf /nix
```

### Environments

`nix-env` create environments, profiles and their generations

* A **Derivation** describes a build action
  - Creates one or more entries in the Nix Store
* Package name equals the derivation name minus the version

```shell
nix search name           # search package
~/.nix-profile            # Nix user profiles
nix-env -q                # list installed derivations
nix-env -q --out-path     # ^ with abosulute path
nix-env -qa 'name.*'      # list available packages
nix-env -i name           # install package
nix-env -e name           # un-install package
nix-env --rollback        # rollback to the old generation
```

A **Generation** is past version of an environment, rollback facilities rely on
Generations:

```shell
nix-env --list-generations
nix-env --switch-generation 
```

### Channels

Manage channels (unstable by default) with `nix-channel`:

<https://nixos.wiki/wiki/Nix_channels>  
<https://nixos.org/manual/nix/stable/#sec-channels>

* A "channel" is a name for the latest "verified" git commits in Nixpkgs.
* Channel user will benefit from both verified commits and binary packages from
  the binary cache.

<https://nixos.org/channels/>  
<https://status.nixos.org/>  
<https://channels.nix.gsc.io/>

* `stable` conservative updates
  - only bug fixes and security patches
  - release every six month
* `unstable` latest updates, rolling basis

```shell
~/.nix-channels           # configuration
nix-channel --list        # current channel
```

To update the channel run:

```shell
nix-channel --update
nix-env -u  # upgrade all packages in the environment
```

* Downloads the new Nix expressions (descriptions of the packages)
* Creates a new generation of the channels profile and unpack it under
  `~/.nix-defexpr/channels`


### Nix Store

```shell
/nix/store                # read-only data store
/nix/var/nix/db           # Nix database
nix-store --optimise      # save space by hardlinking store files
nix-store --gc            # clean up storage
# see which result files prevent garbage collection
nix-store --gc --print-roots
# list run-time dependencies for derivation (i.e. Firefox)
nix-store -q --references $(which firefox)
# ^ recursive as tree
nix-store -q --tree $(which firefox)
```


# References

Nix User manual  
<https://nixos.org/manual/nix/stable/>

Nix package search  
<https://search.nixos.org/packages>
