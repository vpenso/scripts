# Firejail 

The alias script `var/aliases/firejail.sh` adds the configuration to the environment.

Sandboxed configuration for running [opencode](https://opencode.ai) inside a
[Firejail](https://firejail.wordpress.com/) container with minimal privileges.

| File | Purpose | Update-safe |
|---|---|---|
| `opencode.profile` | Main sandbox policy: seccomp, capability drops, filesystem isolation, network rules | No — overwritten on install/update |
| `opencode.local` | User customizations: whitelisted paths, git config, SSH keys, shell tools | Yes |



