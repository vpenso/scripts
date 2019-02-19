File                     | Description
-------------------------|-------------------------------------
[cd2mp3][cd2mp3]         | Extract audio tracks from a CD and convert it into a single MP3
[yt2mp3][yt2mp3]         | Convert a Youtube video into an MP3 file

[cd2mp3]: ../bin/cd2mp3
[yt2mp3]: ../var/aliases/youtube.sh

### Audio

```bash
# dependencies on Arch...
pacman -S youtube-dl cdrtools mp3wrap  
```

Extract audio tracks from a CD and convert it into a single MP3:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP# files
```

### Video

```bash
# dependencies on Debian
apt install vlc libdvd-pkg dvdbackup handbrake          
# dependencies on Arch...
pacman -S vlc libdvdcss dvdbackup handbrake
```

Media player VLC:

<https://www.videolan.org>

Video transcoder Handbrake:

<https://handbrake.fr/>

