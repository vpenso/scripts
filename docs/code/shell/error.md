
## Error Handling

Read about the available signals with `man 7 signal`. Get a short 
signal listing with `kill -l`. 

    EXIT     0         end of program reached
    HUP      1         disconnect 
    INT      2         Interrupt (usally Ctrl-C)
    KILL     9         Stop execution immediatly (can not be trapped)
    TERM     15        default shutdown

Exit and error in a sub-shell, simple cases:

```bash
(c)                # execute command c in sub-shell, ignore errors
(c) || exit $?     # same as above but propagate signal code
```

**Catching Signals**

Execute commands COMMAND on signal SIG

    trap 'COMMAND' SIG [SIG,..]

Trap breaking child processes

```bash
set -m
# rescue function executed by trap
ensure() {
        echo "Clean up after child process died with signal $?."
}
# catch errors
trap ensure ERR
# execute child process
segfaulter &    
# wait for the child process to finish
wait $!
```
