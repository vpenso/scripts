Always use the latest version, on Debian consider using: http://mozilla.debian.net/

Select one of the Firefox `*.js` profiles and link it to `~/.mozilla/firefox/*/user.js`.

    » firefox -profilemanager -no-remote 2>&- & ; disown

Plugins I'm using:

- [VimFx](https://github.com/akhodakivskiy/VimFx)
- [ublock](https://github.com/gorhill/uBlock)
- [Privacy Settings](https://github.com/schomery/privacy-settings/) 


## Container

Firefox in a container: [bootstrap](../../docs/bootstrap.md) a container with with GPT:

```bash
## -- install firefox and audio support in the container -- ##
echo "deb http://mozilla.debian.net/ jessie-backports firefox-release" > /etc/apt/sources.list.d/mozilla.list
apt update && apt -y install -t jessie-backports pkg-mozilla-archive-keyring firefox
apt -y install pulseaudio && echo enable-shm=no >> /etc/pulse/client.conf
## -------------------------------------------------------- ##
sudo systemd-nspawn --setenv=DISPLAY=$DISPLAY \
                    --bind /run/user/$(id -u)/pulse:/run/pulse \
                    --setenv=PULSE_SERVER=/run/pulse/native \
                    --bind /dev/shm \
                    --bind /dev/snd \
                    --image $FIREFOX_NSPAWN_CONTAINER
```

