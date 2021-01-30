
Default browser in X11 settings:

```bas
# search XDG settings for browser keys
xdg-settings --list | grep browser
# show the current default browser
xdg-settings get default-web-browser
```

## Firefox

Install latest version:

```bash
>>> mkdir -p /opt/firefox
# download official version, and extract the archive
>>> sudo cp -r ~/Downloads/firefox-56.0.1/firefox/* /opt/firefox
# backup the executable from the original Debian package
>>> sudo mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr.orig
# link to the custom installation
>>> sudo ln -s /opt/firefox/firefox /usr/lib/firefox-esr/firefox-esr
```

Install Latest version from Debian unstable

```bash
# configure the unstable package repo.
cat > /etc/apt/sources.list.d/unstable.list <<EOF
deb http://http.debian.net/debian unstable main
EOF
# set lowest priority for unstable packages
cat > /etc/apt/preferences.d/unstable <<EOF
Package: *
Pin: release o=Debian,a=unstable
Pin-Priority: 10
EOF
# install firefox
apt update && apt install -y -t unstable firefox
```

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

## Extensions

Privacy Badger  
<https://privacybadger.org/>
