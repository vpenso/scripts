
<kbd>play</kbd> an `*.mp3` file, <kbd>stop</kbd> playback (cf. → [var/aliases/music.sh](../var/aliases/music.sh))

    » play ~/music/….mp3
    » stop

Set the loudness with <kbd>volume</kbd> and <kbd>mute</kbd>:

    » volume 30%
    » mute

Download music from Youtube and convert it to MP3 with <kbd>youtube2mp3</kbd> (cf.→ [var/aliases/youtube.sh](../var/aliases/youtube.sh))

    » youtube2mp3 http://… -o ~/music/…

Control **[Music Player Daemon][2]** with the script ↴<kbd>[music][1]</kbd> (aliased to `m`):

    » m h
    Usage: music [COMMAND] [ARGUMENT]

    music @|crop                Remove songs except current from playlist
    music +|next                Play next song in playlist
    music -|prev                Play previous song in playlist
    music 0                     Remove current song from playlist
    music 1                     Toggles looping
    music a|add PATH            Adds directory to playlist
    music c|clear               Remove all songs from playlist
    music config PATH           Write ~/.mpcconf
    music d|delete NUMS         Remove songs from playlist
    music h|help                Show this text.
    music kill                  Kill MPD daemon
    music l|library [PATH]      Show music in PATH
    music p|playlist            Show current playlist
    music r|play [NUM]          Plays playlist
    music s|stop                Stop playing music
    music u                     Update database

Write a basic `~/.mpdconf` indexing the `~/music` directory:

    » music config ~/music

[1]: ../bin/music
[2]: http://www.musicpd.org/
