
Install `youtube-dl`:

```bash
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
# as Python package
sudo apt install -y python-pip
sudo -H pip install --upgrade youtube-dl
```

Extract an MP3 from Youtube:

```bash
# cf . var/aliases/youtube-dl.sh
yt2mp3 $url                     # download a file from Youtube and convert to MP3
```

Select video quality

```bash
# list available formats
youtube-dl -F $url
# download with a specified format
youtube-dl -f $video[+$audio]
# both should be numerical values
```

### References

[ytdl] Official Web-Site  
https://youtube-dl.org

[ytgh] Github  
https://github.com/ytdl-org/youtube-dl


