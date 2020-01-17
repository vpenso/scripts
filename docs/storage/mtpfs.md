# MTP

The Media Transfer Protocol (MTP) [0] can be used to transfer media files to and 
from mobile devices using Android.

> SIMPLE-MTPFS (Simple Media Transfer Protocol FileSystem) is a file system for 
> Linux capable of operating on files on MTP devices attached via USB to local 
> machine. [1]

```bash
# list connected devices
>>> simple-mtpfs --list-devices
1: SamsungGalaxy models (MTP)
# mount a selected devices
>>> simple-mtpfs --device 1 ~/mnt
# un-mount a selected device
>>> fusermount -u ~/mnt
```

### Build From Source

```bash
# install dependencies
make apt install -y libmtp-dev libfuse-dev
# download release archive from [1]
wget https://github.com/phatina/simple-mtpfs/archive/simple-mtpfs-0.3.0.tar.gz
tar -xzvf simple-mtpfs-0.3.0.tar.gz && cd simple-mtpfs-simple-mtpfs-0.3.0
# build
./autogen.sh
mkdir build && cd build && ../configure
make
# install
sudo make install
```

### References

[0] Media Transfer Protocol (Wikipedia)  
https://en.wikipedia.org/wiki/Media_Transfer_Protocol

[1] SIMPLE-MTPFS Source Code   
https://github.com/phatina/simple-mtpfs/

[2] Arch AUR package for simple-mtpfs  
https://aur.archlinux.org/packages/simple-mtpfs/
