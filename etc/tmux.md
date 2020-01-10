A [terminal multiplexer][tp] Manages multiple terminals within single login session:

* Multiplexs several terminal sessions on a single screen
* Organises terminal with **split panes** and **tabs**
* **Persistence** keeps the terminal sessions during logout until reconnect
* **Session sharing** allows connections to a single sessions from different computers

Commonly used terminal multiplexers are [tmux][tx] and GNU [screen][sc].


## Tmux

File                                  | Description
--------------------------------------|----------------------------------
[etc/tmux.conf](tmux.conf)            | Custom configuration file
[bin/tmux-config](../bin/tmux-config) | Deploy the configuration
[bin/tmux-cheat](../bin/tmux-cheat)   | Custom key binding cheat sheet 

The [tmux][tx] terminal multiplexer, cf.:

* [The Tao of tmux][tb] provides a comprehensive introduction
* The [tmux man-page][tm] describes configuration & operation


```bash
/etc/tmux.conf                  # system configuration file
~/.tmux.conf                    # user configuration file
tmux                            # start tmux
tmux list-sessions              # list running sessions
tmux attach-session             # attach to running sessions
```

Shell aliases:

```bash
# cf. var/aliases/common.sh
alias t=tmux
alias tl="tmux list-sessions"
alias ta="tmux attach-session"
alias tc=tmux-cheat
```

### Configuration

`tmux-config` deploys the custom configuration from this repository:

* Install the [Tmux Plugin Manager][tp] in `~/.tmux/plugins/tpm`
* Write the user configuration to `~/.tmux.conf`

The **prefix key** (default Ctrl-b) is used to send commands to tmux, 
and is customized in the configuration file, e.g.:

```
set-option -g prefix C-a
```

This sets the default leader prefix to **Ctrl-a**.

Install plugins with `<C-a> I`: 

```bash
# plugins to install...
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-pain-control'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-open'
```

[tp]: https://en.m.wikipedia.org/wiki/Terminal_multiplexer
[tx]: https://github.com/tmux/tmux
[sc]: http://www.gnu.org/software/screen/
[tb]: https://leanpub.com/the-tao-of-tmux/read
[tm]: https://manpages.debian.org/tmux
[tp]: https://github.com/tmux-plugins/tpm
