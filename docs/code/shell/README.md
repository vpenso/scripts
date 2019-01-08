
Reference to other documents in this directory:

File                 | Description
---------------------|----------------------------------------
[files.md][fs]       | Files & directories, ls/tree, name conventions, permissions
[history.md][hy]     | Access and manipulate the command history
[scripts.md][sc]     | Shell scripts...
[term.md][tm]        | Text **terminals**, terminal emulators configuration & usage

[fs]: files.md
[hy]: history.md
[sc]: scripts.md
[tm]: term.md

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
* Usually refers to a text interface called [command-line interpreter][cl] (CLI) (e.g. [bash][bs], [zsh][zh])
* A (text) **terminal** is a wrapper program which runs a shell (typically synonymous with a shell)

[bs]: https://en.m.wikipedia.org/wiki/Bash_(Unix_shell)
[cl]: https://en.m.wikipedia.org/wiki/Command-line_interface
[sh]: https://en.m.wikipedia.org/wiki/Shell_(computing)
[zh]: https://en.m.wikipedia.org/wiki/Z_shell

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
  - Reads user input at the command prompt, enable users to enter/execute commands
  - Shells commonly used in interactive mode started by default upon launch of a terminal
* **Non-interactive**
  - A shell executing a script (no human interaction) is always non-interactive
  - Scripts must be executable `chmod +x <script>`

### Cursor

A text [cursor][cu] (aka caret) indicates the current position for user interaction:

* Typically an underscore or solid rectangle or vertical line, flashing or steady
* Indicates the **insertion point** in text mode
* The cursor can be moved by pressing various keys (arrows, page up/down, home/end key, etc.)

Cursor movement, cf. `man readline`:

    tab                   command line completion
    ctrl-r                search command history
    ctrl-l                clear screen
    ctrl-w                delete last word
    alt-b|f               move by word
    ctrl-u|k              delete until start/end of line
    ctrl-a|e              move cursor to beginning/end of line
    ctrl-x ctrl-e         open command in editor

[cu]: https://en.m.wikipedia.org/wiki/Cursor_(user_interface)

### Help

Most executable programs support:

* `-h`, `--help` options that displays a description of the command's supported syntax and options
* `man` [man pages][mn] (manuals) with a detailed command documentation
* `info` displays the official documentation format [textinfo][ti] of the GNU project

```bash
type <command>                 # displays the kind of command the shell will execute
which <command>                # determine the exact location of a given executable
man <command>                  # man page for a given command
info <command>                 # documentation of the GNU project
whatis <command>               # display one-line manual page descriptions                        
apropos <keyword>              # search for commands by keyword
## bash builtin help
help                           # list of builtin commands
help -m <command>              # help for a specific builtin command
```

[mn]: https://en.m.wikipedia.org/wiki/Man_page
[ti]: https://www.gnu.org/software/texinfo/

