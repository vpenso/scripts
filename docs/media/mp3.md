File                             | Description
---------------------------------|--------------------------------
[bin/cd2mp3][02]                 | Read a CD and create a single MP3 file

[02]: ../../bin/cd2mp3

Create/change MP3 audio files:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP3 files
# set ID3 description
mp3info -t $title -a $artist -n $track $file.mp3
```
