## Git

Deploy my custom Git configuration:

File                              | Description
----------------------------------|----------------------------------
[etc/gitconfig](gitconfig)        | User configuration file
[etc/gitignore_global](gitconfig) | Rules for ignoring files in every Git repository

```bash
diffcp $SCRIPTS/etc/gitconfig ~/.gitconfig
diffcp $SCRIPTS/etc/gitignore_global ~/.gitignore_global
```

