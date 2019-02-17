File                     | Description
-------------------------|-------------------------------------
[cd2mp3][cd2mp3]         | Extract audio tracks from a CD and convert it into a single MP3

[cd2mp3]: ../bin/cd2mp3

### Audio

```bash
pacman -S cdrtools mp3wrap                              # dependencies on Arch/etc
```

Extract audio tracks from a CD and convert it into a single MP3:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP# files
```

### Video

```bash
apt install vlc libdvd-pkg dvdbackup handbrake          # install components on Debian
```

Media player VLC:

<https://www.videolan.org>

Video transcoder Handbrake:

<https://handbrake.fr/>

