## Music Player Daemon (MPD)

File                      | Description
--------------------------|---------------------------
[etc/mpdconf][01]         | Daemon configuration file, expects the library in `~/music`
[var/aliases/mpd.sh][02]  | Sets the `mpd` daemon environment, and starts the service
[var/aliases/mpc.sh][03]  | Wrapper function for the `mpc` client, aliases to `m`

Use `m` alias command to interact with [`mpd`][m2]:

```bash
>>> m h                 # aka mpc-alias help
@,  crop                Remove songs except current from playlist
+,  next                Play next song in playlist
-,  prev                Play previous song in playlist
~                       Remove current song from playlist
1                       Toggles looping
a,  add PATH            Adds directory to playlist
c,  clear               Remove all songs from playlist
    conf                Show MPD configuration
d,  delete <num>        Remove songs from playlist
k,  kill                Kill MPD daemon
l,  list                List library
pl, playlist            Show current playlist
p,  play <num>          Plays playlist
s,  stop                Stop playing music
sa                      search in music dir and add to playlist
sr                      search in music dir and replace playlist
u,  update              Update database
v,  volume [+-]<num>     Adjust volume between 0-100 (+- for relative numbers)
```

The command above is a shell function wrapper script for [`mpc`][m1] used to 
control your local `mpd` instance:

```bash
>>> which mpc
mpc: aliased to mpc --host 127.0.0.1 -p $MPD_PORT
>>> which m
m: aliased to mpc-alias
```

Sub-commands `m sa|sr` us [`fzf`][m3] to search in the music library.


[01]: ../../etc/mpdconf
[02]: ../../var/aliases/mpd.sh
[03]: ../../var/aliases/mpc.sh

[m1]: https://man.cx/mpc
[m2]: https://man.cx/mpd
[m3]: https://man.cx/fzf


