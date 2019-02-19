
## Shell

**Why, learn it?**

* Long **lasting knowledge** unlike many other computer skills
* Powerful **expressive** way of communicating with a computer
* Complete (technically advanced) **control** over the system components
* Facilitates **automation** for time consuming repetitive tasks
* **Diversity** of tooling and interfaces (makes difficult tasks possible)
* Improves **productivity** with increased proficiency

A [shell][sh] is a **user-interface** to system functions and other applications 

* Shells fall into one of two categories – **command-line** and graphical
* A [**terminal** emulator][te] is a wrapper interfacing a shell with the OS, i.e. [xterm][xt]
* Usually refers to a [command-line interface][cl] (CLI), i.e. [Bash][bs] and [Zsh][zh]
* Also a [text user interface][tx] (TUI) runs in a terminal, i.e. [Vim][vi] (text editor)

Note: Many use shell, terminal and console as synonym 

[bs]: https://en.wikipedia.org/wiki/Bash_(Unix_shell)
[cl]: https://en.wikipedia.org/wiki/Command-line_interface
[sh]: https://en.wikipedia.org/wiki/Shell_(computing)
[zh]: https://en.wikipedia.org/wiki/Z_shell
[te]: https://en.wikipedia.org/wiki/Terminal_emulator
[tx]: https://en.wikipedia.org/wiki/Text-based_user_interface
[xt]: https://en.wikipedia.org/wiki/Xterm
[vi]: https://en.wikipedia.org/wiki/Vim_(text_editor)

---

## Command-line Interpreter

The **prompt** indicates readiness to accept command input by the user

- Literally prompts the user to take action
- Customizable with environment variables
- May include information like user/hostname, working directory, etc.

**Commands** are a large vocabulary of instructions and queries:

Type        | Description
------------|-----------
Internal    | Recognized and processed by the command line interpreter itself
Included    | Separate executable file part of the operating system
External    | Executables added by other parties for specific purposes/applications

**Parameters** are required and/or optional arguments/options to commands:

- **Arguments** are positional inputs to the command
- **Options** (flags/switches) modify the operation of a command

Delimiters between commands - **white space** characters and the end-of-line delimiter


---

## Cursor & Keys

A text [cursor][cu] (aka caret) indicates the current position for user interaction:

* Typically an underscore or solid rectangle or vertical line, flashing or steady
* Indicates the **insertion point** in text mode
* Moved by pressing various keys (arrows, page up/down, home/end key, etc.)

**Key bindings** tie key sequences to specific functions, cf. `man readline`:

Key      | Description
---------|-----------------------------
Tab      | command line completion
Ctrl-r   | search command history
Ctrl-c   | break current execution
Ctrl-a   | cursor to beginning of line
Ctrl-e   | cursor to end of line
Ctrl-l   | clear screen
Ctrl-u   | discard line

Aka [keyboard shortcuts][keys] are a series of several keys to invoke/trigger an operation

[cu]: https://en.m.wikipedia.org/wiki/Cursor_(user_interface)
[keys]: https://en.wikipedia.org/wiki/Keyboard_shortcut#Customization

---

## Help

Most programs (commands) provide [manual pages][mn] (manuals):

* Include a detailed documentation, usually with references to other documents
* `man` uses a [terminal pager][pager] program such as `more` or `less` to display its output
* `info` displays the official documentation format [textinfo][ti] of the GNU project

By convention most  programs support the options `-h`, `--help` with a **usage summery**

In general **documentation** is accessible with following commands:

```bash
man <command>                  # man page for a given command
info <command>                 # documentation of the GNU project
whatis <command>               # display one-line manual page descriptions
apropos <keyword>              # search for commands by keyword
## bash builtin help
help                           # list of builtin commands
help -m <command>              # help for a specific builtin command
```

Uses `curl` to query a web-service https://cheat.sh/ documentation search

```bash
curl cheat.sh/tar
curl cht.sh/curl
curl https://cheat.sh/ruby/file
curl https://cht.sh/go/Pointers
```

Cf. Github:[chubin/cheat.sh](https://github.com/chubin/cheat.sh)

[mn]: https://en.m.wikipedia.org/wiki/Man_page
[ti]: https://www.gnu.org/software/texinfo/
[pager]: https://en.wikipedia.org/wiki/Terminal_pager

---

## Shell Mode

Two modes of operations:

* **Interactive**
  - Reads user input at the command prompt, enable users to enter/execute commands
  - Shells commonly used in interactive mode started by default upon launch of a terminal
* **Non-interactive**
  - A shell executing a script (no human interaction) is always non-interactive
  - Scripts must be executable `chmod +x <script>`
