File                     | Description
-------------------------|-------------------------------------
[cd2mp3][cd2mp3]         | Extract audio tracks from a CD and convert it into a single MP3
[yt2mp3][yt2mp3]         | Convert a Youtube video into an MP3 file

[cd2mp3]: ../bin/cd2mp3
[yt2mp3]: ../var/aliases/youtube.sh

### Audio

```bash
# verify that sound modules are loaded
lsmod | grep '^snd' | column -t
# list audio devices
aplay -l
aplay -L | grep :CARD
# produce noise on a device
speaker-test -D default:PCH -c 2
# dependencies on Arch...
pacman -S youtube-dl cdrtools mp3info mp3wrap
```

Create/change MP3 audio files:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP3 files
# set ID3 description
mp3info -t $title -a $artist -n $track $file.mp3
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

