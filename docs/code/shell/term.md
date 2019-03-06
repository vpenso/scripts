
## Terminal

Text terminals is a serial computer interface for text entry and display:

* Historically [keyboard/screen][tm] for display and input of data on a remote computer
* [Terminal emulators][te] mimic a hardware (video) terminal in software
* A system **console** is a special terminal 
  - On modern computers a directly connected monitor/keyboard
  - Receives messages from the OS regarding booting/shutdown progress
  - Linux support **virtual consoles** to provide several text terminals
  - Access with a key combination including function keys (e.g. Ctrl+Alt+F2)
* [Control characters][cc] display control codes like line-feed, backspace, etc.
* [Escape sequences][es], series of characters that give commands to the terminal
  - User for cursor movement, colors, etc.
  - Consists of the `ESC` control character followed by a sequence of characters

```bash
/dev/tty[0-9]               # teletypes, cf. man `tty`
/dev/pts/[0-9]              # pseudo terminals, cf man `pty`
tty                         # show assoc. pseudo terminal
stty -a                     # show terminal settings
getty                       # program watching a physical terminal (tty) port
ps -a                       # list processes with attached terminals
terminfo 
termcap                     # terminal capability data base
tput
tget
reset                       # init terminal
```

[cc]: https://en.m.wikipedia.org/wiki/Control_character
[es]: https://en.m.wikipedia.org/wiki/Escape_sequence
[te]: https://en.wikipedia.org/wiki/Terminal_emulator
[tm]: https://en.m.wikipedia.org/wiki/Computer_terminal

---

## Terminal Multiplexer

A [terminal multiplexer][tp] Manages multiple terminals within single login session:

* Multiplexs several terminal sessions on a single screen
* Organises terminal with **split panes** and **tabs**
* **Persistence** keeps the terminal sessions during logout until reconnect
* **Session sharing** allows connections to a single sessions from different computers

Commonly used terminal multiplexers are [tmux][tx] and GNU [screen][sc].

[tp]: https://en.m.wikipedia.org/wiki/Terminal_multiplexer
[tx]: https://github.com/tmux/tmux
[sc]: http://www.gnu.org/software/screen/

---

### tmux

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

The **prefix key** (default Ctrl-b) is used to send commands into tmux, and is customized in the configuration file, e.g.:

```
set-option -g prefix C-a
```

This sets the default leader prefix to **Ctrl-a**.

File                       | Description
---------------------------|------------------------------------------------
[var/aliases/tmux.sh][ta]  | Load custom tmux configuration from this repository
[etc/tmux.conf][tc]        | Example tmux configuration file within this repository
[bin/tmux-cheat][th]       | Print minimal tmux cheat sheet for above configuration


[ta]: ../../../var/aliases/tmux.sh
[tb]: https://leanpub.com/the-tao-of-tmux/read
[tc]: ../../../etc/tmux.conf
[th]: ../../../bin/tmux-cheat
[tm]: https://manpages.debian.org/tmux

