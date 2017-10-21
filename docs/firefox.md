
Plugins I'm using:

- [VimFx](https://github.com/akhodakivskiy/VimFx)
- [ublock](https://github.com/gorhill/uBlock)
- [Privacy Settings](https://github.com/schomery/privacy-settings/) 

### Container

Use → [Firejail](https://firejail.wordpress.com/) to run Firefox as untrusted application in a restricted environment:

```bash
# modify original firefox profile in your home-dirctory
>>> cp /etc/firejail/firefox.profile ~/.config/firejail/
# whitelist additional directories in the custom profile
>>> grep Video  ~/.config/firejail/firefox.profile
noblacklist ~/Video
whitelist ~/Video
# start firefox in a sandbox
>>> firejail firefox
# start firefox as another user in a sandbox
>>> gksu -l -u <user> firejail firefox
```

Use `systemd-nspawn` to run firefox in a container: 

* [bootstrap](../../docs/bootstrap.md) a container with GPT
* Us ↴ [firefox-container](../../bin/firefox-container) for execution

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

