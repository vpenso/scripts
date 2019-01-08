# Shell

A [shell][sh] is a user-interface for access to an operating-system.

* Shells fall into one of two categories – command-line and graphical
* "Shell" typically refers to a text interfaces called **command-line interpreter** (CLI)
* A (text) **terminal**  is a wrapper program which runs a shell (typically synonymous with a shell)
  - Historically an [electromechanical hardware device][tm] (e.g. keyboard/screen) for display and input of data (on a mainframe computer)
  - [Terminal emulators][te] mimic a hardware (video) terminal in software
* A **console** is a special terminal (on a modern computer typically the monitor)
  - Receives messages from the kernel regarding booting and shutdown progress
  - Modern Linux systems provide **virtual consoles**
  - Access with a key combination including function keys (e.g. Ctrl+Alt+F2)

[sh]: https://en.m.wikipedia.org/wiki/Shell_(computing)
[tm]: https://en.m.wikipedia.org/wiki/Computer_terminal
[te]: https://en.wikipedia.org/wiki/Terminal_emulator

**Why, learn it?**

* Long **lasting knowledge** unlike many other application computer skills
* Powerful **expressive** way of communicating with a computer
* Complete **control** over the operating system components and their operation
* Facilitates **automation** for time consuming repetitive tasks
* **Diversity** of tooling and interfaces (makes difficult tasks possible)
* Improves **productivity** with increased proficiency

### Terminals

Terminal devices

* `/dev/tty[0-9]` (teletypes, cf. manual `tty`)
* `/dev/ttyS[0-9]` (serial port terminals)
* `/dev/pts/[0-9]` (pseudo terminals)
  - Virtual terminal connected to a terminal program i.e. `xterm`
  - Cf. `pty` (pseudo-tty driver) manual
* `getty` program watching a physical terminal (tty) port

```bash
tty                         # show assoc. pseudo terminal
stty -a                     # show terminal settings
ps -a                       # list processes with attached terminals
terminfo 
termcap                     # terminal capability data base
tput
tget
reset                       # init terminal
```

**Control characters** - Display control codes like line-feed, backspace, etc. 

**Escape sequences** - Series of characters that give commands to the terminal

* User for cursor movement, colors, etc.
* Consists of the ESC control character followed by a sequence of ordinary characters

## Shells

* **Interactive**
  - Reads user input on a tty, enable users to enter/execute commands
  - Shells commonly used in interactive mode started by default upon launch of a terminal
* **Non-interactive**
  - A shell executing a script (no human interaction) is always non-interactive
  - Scripts must be executable `chmod +x <script>`

If a script requires input from the users it is called **interactive script**.

Executing a script:

```bash
/path/to/script            # (recommended) interpreted defined by shabang line
/bin/bash /path/to/script  # interpreter followed by the path to a script
bash /path/to /script      # assumes bash is in PATH
```

The first line may indicate the script interpreter with a 
`#!` (shabang), i.e. the absolute path to the interpreter
executable:

```bash
#!/bin/bash
```

Execute a script file with the bash executable found in 
the `PATH` environment variable:

```bash
#!/usr/bin/env bash
```

Cursor movement, cf. `man readline`:

    tab            command line completion
    ctrl-r         search command history
    ctrl-l         clear screen
    ctrl-w         delete last word
    alt-b|f        move by word
    ctrl-u|k       delete until start/end of line
    ctrl-a|e       move cursor to beginning/end of line         
    ctrl-x ctrl-e  open command in editor
