
## Audio

Create/change MP3 audio files:

```bash
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP3 files
# set ID3 description
mp3info -t $title -a $artist -n $track $file.mp3
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





