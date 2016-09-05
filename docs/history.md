↴ [var/aliases/history.sh](../var/aliases/history.sh)

The shell maintains a list of **recently executed commands**, so called events.

    history        show command history
    fc             invoke editor to edit last command
    fc n           edit command n in history

History event designators:

    !              start to reference history event
    !!             previous command
    !*             last argument list
    !n             command n in history
    !-n            the n preceding commands
    !s             most recent command starting with string s
    !?s            most recent command containing string s

Event modifier appended to an event, e.g. `!3:*` (use
multiple modifiers like `!!:-4:p`:

    :              modifier prefix
    :n             nth word (word 0 is the command)
    :^             first word
    :$             last word
    :-             all words until the last
    :-n            all words including the nth
    :m-n           words from m to n
    :n*            wall words from n to the last
    :*             all words except the command
    :p             print, but not execute
    :r             remove the filename extension
    :e             remove all but the file name extension
    :h             remove last part from a path
    :s/P/S/        replace first match of pattern P with string S
    :gs/P/S/       like above, but replace all matches

Quick substitute `^P^S^` similar to `!!:s/P/S/`. 

```bash
setopt kshoptionprint && setopt | grep hist      # show Zsh history settings
printenv | grep HIST                             # ^^ show environment variables
```
