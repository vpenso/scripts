
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





