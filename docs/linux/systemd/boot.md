Systemd kernel command-line arguments [1]:

```bash
console=ttyS1,38400 console=tty0         # configure the serial console [2]
systemd.log_level=debug                  # enable debugging output
systemd.log_target=console               # send debugging output to serial console
systemd.journald.forward_to_console=1    # configure journald to forward to the console
systemd.debug-shell=1                    # enable shell access early in the startup process to fall back on and diagnose systemd
systemd.confirm_spawn=1                  # asks for confirmation when spawning processes
systemd.unit=rescue.target               # boot directly into rescue target (if problem occurs somewhere after the basic system is brought up)
systemd.unit=emergency.target            # boot directly into emergency shell
init=/bin/sh                             # boot directly into a shell (no systemd as PID 1)
```

### References

[1] Systemd - Diagnosing Boot Problems  
<https://freedesktop.org/wiki/Software/systemd/Debugging/>

[2] Linux Serial Console  
<https://www.kernel.org/doc/html/v4.14/admin-guide/serial-console.html>

[3] Systemd - Kernel Command Line  
<https://www.freedesktop.org/software/systemd/man/kernel-command-line.html>


