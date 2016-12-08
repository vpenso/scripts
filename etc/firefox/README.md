Always use the latest version, on Debian consider using: http://mozilla.debian.net/

Select one of the Firefox `*.js` profiles and link it to `~/.mozilla/firefox/*/user.js`.

    » firefox -profilemanager -no-remote 2>&- & ; disown

Plugins I'm using:

- [VimFx](https://github.com/akhodakivskiy/VimFx)
- [ublock](https://github.com/gorhill/uBlock)
- [Privacy Settings](https://github.com/schomery/privacy-settings/) 


Firefox in a container, [bootstrap](../../docs/bootstrap.md) Debian to `$rootfs`:

```
# install Firefox and audio
sudo chroot $rootfs /bin/bash -c "apt-get install iceweasel pulseaudio -y && echo enable-shm=no >> /etc/pulse/client.conf"
# create a user account
sudo chroot $rootfs /bin/bash -c "useradd -u $(id -u) -m -U -G audio $USER"
# start firefox in a container
sudo systemd-nspawn --setenv=DISPLAY=unix$DISPLAY \
                    --bind /run/user/$(id -u)/pulse:/run/pulse \
                    --setenv=PULSE_SERVER=/run/pulse/native \
                    --bind /dev/shm \
                    --bind /dev/snd \
                    -u $USER -D $rootfs firefox
```

