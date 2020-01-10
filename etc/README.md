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

## Tmux

Shell aliases:

```bash
>>> grep tmux $SCRIPTS/var/aliases/common.sh
alias t=tmux
alias tl="tmux list-sessions"
alias ta="tmux attach-session"
alias tc=tmux-cheat
```

Deploy my custom Tmux configuration:

File                                  | Description
--------------------------------------|----------------------------------
[etc/tmux.conf](tmux.conf)            | Custom configuration file
[bin/tmux-config](../bin/tmux-config) | Deploy the configuration
[bin/tmux-cheat](../bin/tmux-cheat)   | Custom key binding cheat sheet 

`tmux-config` will make following modifications:

* Install the [Tmux Plugin Manager][tpm] in `~/.tmux/plugins/tpm`
* Write the user configuration to `~/.tmux.conf`

This configuration uses CTRL-a `<C-a>` as default leader prefix.

Start Tmux and install following plugins with `<C-a> I`: 

```bash
# plugins to install...
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-pain-control'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-open'
```

[tpm] https://github.com/tmux-plugins/tpm
