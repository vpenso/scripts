File                             | Description
---------------------------------|--------------------------------
[bin/cd2mp3][02]                 | Read a CD and create a single MP3 file

[02]: ../../bin/cd2mp3

Create/change MP3 audio files:

```bash
apt install -y icedax mp3wrap lame     # install tools on Debian
cat /proc/sys/dev/cdrom/info           # find the CD/DVD drive
lsblk                                  # look for type `rom`
icedax -D /dev/sr0                     # extract WAV from CD (default audio.wav)
ffmpeg -i audio.wav -acodec mp3 $name  # convert WAV to MP3
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP3 files
# set ID3 description
mp3info -t $title -a $artist -n $track $file.mp3
```
