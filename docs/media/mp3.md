File                             | Description
---------------------------------|--------------------------------
[var/aliases/youtube-dl.sh][01]  | Aliase, shell functions for `youtube-dl`
[bin/cd2mp3][02]                 | Read a CD and create a single MP3 file

[01]: ../../var/aliases/youtube-dl.sh
[02]: ../../bin/cd2mp3

Install [youtube-dl](https://youtube-dl.org/) as Python package:

```bash
sudo apt install -y python-pip
sudo pip install --upgrade youtube_dl
```

```bash
yt2mp3 $url                     # download a file from Youtube and convert to MP3
```

Create/change MP3 audio files:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP3 files
# set ID3 description
mp3info -t $title -a $artist -n $track $file.mp3
```
