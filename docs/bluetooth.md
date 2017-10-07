
```bash
## install bluetooth support
>>> apt-get install pulseaudio pulseaudio-module-bluetooth pavucontrol bluez-firmware
## restart the bluetooth daemon
>>> service bluetooth restart
## restart audio
>>> killall pulseaudio
```

Use the Gnome Bluetooth applet to connect.

A2DP sink problem on Debian:

```bash
>>> sudo cat /var/lib/gdm3/.config/pulse/client.conf
autospawn = no
daemon-binary = /bin/true
>>> sudo chown Debian-gdm:Debian-gdm /var/lib/gdm3/.config/pulse/client.conf
>>> sudo rm /var/lib/gdm3/.config/systemd/user/sockets.target.wants/pulseaudio.socket
>>> sudo grep on-connect /etc/pulse/default.pa
load-module module-switch-on-connect
```
