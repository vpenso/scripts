Single user installation:

```shell
sudo mkdir /nix
sudo chown $USER:$USER /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source ~/.nix-profile/etc/profile.d/nix.sh
# unsinstall
rm -rf /nix
```

### Nix Store

Software is a graph of dependencies:

* This graph typically implicit
* Nix makes this graph explicit

```shell
/nix/store                # (directed acyclic) graph (database)
/nix/store/*              # nodes (immutable)
```

Nodes include references to paths in other nodes (edges).

* Each node is prefixed by a (unique) hash
* For a given hash its Contents is always identical across machines/platforms
* Can't be modified after creation (immutable)

```
/nix/store/gv4rgr1p1dq5s4hx7ald6a7kli6p3xrz-firefox-85.0
           |                              | |
           |                              | `----------- name
           `------------------------------`------------- hash
```

Query the nix store like a graph database:

```shell
# list run-time dependencies for derivation (i.e. Firefox)
nix-store --query --references $(which firefox)
# ^ recursive as tree
nix-store --query --tree $(which firefox)
# plot a graph
nix-store --query --graph $(which firefox) | dot -Tsvg
```

```shell
nix-store --optimise      # save space by hardlinking store files
nix-store --gc            # clean up storage
# see which result files prevent garbage collection
nix-store --gc --print-roots
```

### Derivations

* Derivations recipe how to build other paths in the Nix store
  - Special entries in the nix store `/nix/store/*.drv`
  - Includes references to all dependency nodes
  - Creates one or more entries in the Nix Store
* Derivation definition includes
  - `outputs` - What nodes can this build
  - `inputDrvs` - Other derivation that must be build before
  - `inputSrcs` - Nodes already in the store on which this build depends
  - `platform` - build platform
  - `builder` - program to run for the build
  - `args` - program argument list
  - `env` - build environment
* Only contents referenced in the derivation available during build
  - No implicit dependencies possible
  - All dependencies made explicit
  - All dependencies codified in the output hash
  - Nothing is machine dependent (good for binary caching)

Build a derivation with `nix-build`:

```shell
nix-build /nix/store/lzha201i0b0d52rjxqlxbrximwf9bjiv-firefox-85.0.drv
```

Any software build/install can be a binary download with no other prerequisites
except the nix platform.

### Environments

`nix-env` create environments, profiles and their generations

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



# References

Nix User manual  
<https://nixos.org/manual/nix/stable/>

Nix package search  
<https://search.nixos.org/packages>
