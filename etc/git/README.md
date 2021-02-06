## Git

```shell
# install from Nix packages
nix-env -i git delta
```

Deploy my custom Git configuration:

File                              | Description
----------------------------------|----------------------------------
[gitconfig](gitconfig)            | User configuration file
[gitignore_global](gitconfig)     | Rules for ignoring files in every Git repository
[var/aliases/git.sh][01]          | Load the `git` configuration to the environment

```bash
# install the configuration manually 
diffcp $SCRIPTS/etc/git/gitconfig ~/.gitconfig
diffcp $SCRIPTS/etc/git/gitignore_global ~/.gitignore_global
```

[01]: ../../var/aliases/git.sh
