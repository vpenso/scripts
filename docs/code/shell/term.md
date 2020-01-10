
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
