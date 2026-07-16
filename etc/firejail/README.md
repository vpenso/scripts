# Firejail 

Sandboxed configuration for running Firejail[^KL32s] container with minimal privileges.

[^KL32s]: Firejail  
<https://firejail.wordpress.com>  
<https://github.com/netblue30/firejail>

Existing profiles are stored in `/etc/firejail`

The alias script [`var/aliases/firejail.sh`](../../var/aliases/firejail.sh) install custom profiles to `~/.config/firejail`

 File              | Purpose
-------------------|----------------------------------------------
`opencode.profile` | No official Opencode profile yet, set the baseline
`opencode.local`   | Whitelist Opencode for user requirements
`pi.profile`       | No official PI profile yet, set the baseline
`pi.local`         | Whitelist PI agent for user requirements


