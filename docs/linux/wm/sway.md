
## Screenshare

DBus tools for emulating gnome-screenshot on Wayland's wlroots  
<https://gitlab.com/jamedjo/gnome-dbus-emulation-wlr>

With a video loopback device:

```bash
sudo apt install -y libavdevice-dev v4l2loopback-utils v4l2loopback-dkms
sudo modprobe v4l2loopback
# list dummy video devices
v4l2-ctl --list-devices
v4l2-ctl --device=/dev/video0 --info
# record screen
wf-recorder --muxer=v4l2 --codec=rawvideo --pixel-format=yuv420p --file=/dev/video0
# display the video stream for sharing
ffplay /dev/video0
```
