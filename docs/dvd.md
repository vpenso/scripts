
```bash
apt install vlc libdvd-pkg dvdbackup handbrake          # install components on Debian
pacman -S cdrtools mp3wrap                              # dependencies on Arch/etc
```

Media player VLC:

<https://www.videolan.org>

Video transcoder Handbrake:

<https://handbrake.fr/>

```bash
cdrecord dev=/dev/sr0 -checkdrive      # information about the drive
cdda2mp3 dev=/dev/sr0                  # copy music tracks from CD in given drive
mp3wrap output.mp3 *.mp3               # concatenate MP# files
```
