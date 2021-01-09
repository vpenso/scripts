
<https://github.com/lolilolicon/FFcast>

```
# dependencies on Debian
sudo apt install -y ffmpeg imagemagick x11-utils
# get the source code
git clone --recursive https://github.com/lolilolicon/FFcast.git && ffcast
./bootstrap  # generates ./configure
# build & install
./configure --prefix /usr --libexecdir /usr/lib --sysconfdir /etc
make
sudo make DESTDIR="$dir" install  # $dir must be an absolute path
```
