Always use the latest version, on Debian consider using: http://mozilla.debian.net/

Select one of the Firefox `*.js` profiles and link it to `~/.mozilla/firefox/*/user.js`.

    » firefox -profilemanager -no-remote 2>&- & ; disown

Plugins I'm using:

- [VimFx](https://github.com/akhodakivskiy/VimFx)
- [ublock](https://github.com/gorhill/uBlock)
- [Privacy Settings](https://github.com/schomery/privacy-settings/) 


## Continer

Firefox in a container, [bootstrap](../../docs/bootstrap.md) Debian to `$rootfs`:

```
fakeroot fakechroot /usr/sbin/debootstrap jessie $rootfs    # boostrap the basic OS tree
sudo systemd-nspawn -D $rootfs                              # chroot to OS tree
## -- inside the container -- ##
echo "deb http://mozilla.debian.net/ jessie-backports firefox-release" > /etc/apt/sources.list.d/mozilla.list
apt update && apt -y install iceweasel                     
apt -y install pulseaudio && echo enable-shm=no >> /etc/pulse/client.conf
                                                           # configure audio
useradd -m -U -G audio firefox                             # create a user account
echo -e "[Link]\nName=host0" > /etc/systemd/network/10-host0.link
echo -e "[Match]\nName=host0\n[Network]\nDHCP=yes" > /etc/systemd/network/11-host0.network
systemctl enable systemd-networkd                          # prepare the network configuration
## -- exit the container -- ##
# start firefox in a container
tmp_rootfs=/tmp/firefox-$(date +%Y%m%dT%H%M%S) ; cp -R $rootfs $tmp_rootfs
sudo systemd-nspawn --network-veth --network-bridge=nbr0 \
                    --setenv=DISPLAY=unix$DISPLAY \
                    --bind /run/user/$(id -u)/pulse:/run/pulse \
                    --setenv=PULSE_SERVER=/run/pulse/native \
                    --bind /dev/shm \
                    --bind /dev/snd \
                    -u firefox -D $tmp_rootfs
```

