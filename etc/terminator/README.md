Install the configuration file:

```bash
# download and install Inconsolata fonts
$SCRIPTS/bin/font-install-nerdfonts
# install the configuration file
diffcp -r $SCRIPTS/etc/terminator/config ~/.config/terminator/config
```

After changes via the preferences menu:

```bash
# compate to the repository configuration
diff ~/.config/terminator/config $SCRIPTS/etc/terminator/config
# add the changes to the repository
cp ~/.config/terminator/config $SCRIPTS/etc/terminator/config
```

[docs] Terminator’s documentation  
https://terminator-gtk3.readthedocs.io/
