File                     | Description
-------------------------|-------------------------------------
[cd2mp3][cd2mp3]         | Extract audio tracks from a CD and convert it into a single MP3
[yt2mp3][yt2mp3]         | Convert a Youtube video into an MP3 file

[cd2mp3]: ../bin/cd2mp3
[yt2mp3]: ../var/aliases/youtube.sh

## Audio

```bash
# Debian
apt install -y alsa-utils pulseaudio
# dependencies on Arch...
pacman -S youtube-dl cdrtools mp3info mp3wrap
```


```
dmesg | egrep -i "alsa|snd" # kernel messages for sound devices
# list available kernel modules
find /lib/modules/$(uname -r)/kernel/sound/
/proc/asound/cards          # sound devices detected by ASLA
# verify that sound modules are loaded
lsmod | grep '^snd' | column -t
# list audio devices
aplay -l
aplay -L | grep :CARD
# produce noise on a device
speaker-test -D default:PCH -c 2
```

Create/change MP3 audio files:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP3 files
# set ID3 description
mp3info -t $title -a $artist -n $track $file.mp3
```

### Pulseaudio

```bash
# input sources (* indicates current default)
pacmd list-sources | grep -e 'index:' -e device.string -e 'name:'
# output sources
pacmd list-sinks | grep -e 'name:' -e 'index:'
```


## Video

```bash
# dependencies on Debian
apt install vlc libdvd-pkg dvdbackup handbrake          
# dependencies on Arch...
pacman -S vlc libdvdcss dvdbackup handbrake
```


### Youtube-dl

Select video quality

```bash
# list available formats
youtube-dl -F $url
# download with a specified format
youtube-dl -f $video[+$audio]
# both should be numerical values
```





