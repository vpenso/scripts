# Shell

**Why, learn it?**

* Long **lasting knowledge** unlike many other computer skills
* Powerful **expressive** way of communicating with a computer
* Complete (technically advanced) **control** over the system components
* Facilitates **automation** for time consuming repetitive tasks
* **Diversity** of tooling and interfaces (makes difficult tasks possible)
* Improves **productivity** with increased proficiency

A [shell][sh] is a user-interface for access to an operating-system:

* Shells fall into one of two categories – command-line and graphical
* Usually refers to a text interface called [command-line interpreter][cli] (CLI) (e.g. [bash][bs], [zsh][zh])
* A (text) **terminal** is a wrapper program which runs a shell (typically synonymous with a shell)

## Terminal

Text terminals is a serial computer interface for text entry and display:

* Historically [keyboard/screen][tm] for display and input of data on a remote computer (central mainframe)
* [Terminal emulators][te] mimic a hardware (video) terminal in software
* A system **console** is a special terminal (on modern computers a directly connected monitor/keyboard)
  - Receives messages from the OS regarding booting/shutdown progress
  - Modern Linux systems support **virtual consoles** to provide several text terminals on a single computer
  - Access with a key combination including function keys (e.g. Ctrl+Alt+F2)
* [Control characters][cc] display control codes like line-feed, backspace, etc.
* [Escape sequences][es], series of characters that give commands to the terminal
  - User for cursor movement, colors, etc.
  - Consists of the ESC control character followed by a sequence of ordinary characters

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

## Command Interpreters

Anatomy of a command-line:

* The **prompt** indicate readiness to accept command input by the user
  - Literally prompts the user to take action
  - Customizable, may include information like user/hostname, working directory, etc. 
* **Commands** are a large vocabulary of instructions and queries:
  - Internal - recognized and processed by the command line interpreter itself
  - Included - separate executable file part of the operating system
  - External - executable files added by other parties for specific purposes and applications
* **Parameters** are required and/or optional arguments/options to commands:
  - **Arguments** are positional inputs to the command
  - **Options** (flags/switches) modify the operation of a command
* Delimiters between command line elements are whitespace characters and the end-of-line delimiter

Two modes of operations:

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

### Shebang

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



[bs]: https://en.m.wikipedia.org/wiki/Bash_(Unix_shell)
[cc]: https://en.m.wikipedia.org/wiki/Control_character
[cl]: https://en.m.wikipedia.org/wiki/Command-line_interface
[es]: https://en.m.wikipedia.org/wiki/Escape_sequence
[sh]: https://en.m.wikipedia.org/wiki/Shell_(computing)
[tm]: https://en.m.wikipedia.org/wiki/Computer_terminal
[te]: https://en.wikipedia.org/wiki/Terminal_emulator
[zh]: https://en.m.wikipedia.org/wiki/Z_shell
