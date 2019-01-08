
## Scripts

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
