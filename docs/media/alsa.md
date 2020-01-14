ALSA (Advanced Linux Sound Architectur)

* Kernel sound card drivers
* User space driven library for application developers
* Users have permission to play audio and change mixer levels


```bash
sudo apt install -y alsa-utils    #  install on Debian
sudo dmesg | egrep -i "alsa|snd"  # kernel messages for sound devices
# list available kernel modules
find /lib/modules/$(uname -r)/kernel/sound/
/proc/asound/cards          # sound devices detected by ASLA
# verify that sound modules are loaded
lsmod | grep '^snd' | column -t
```

```bash
amixer                            # configure audio settings
alsamixer                         # ..using a TUI
# list audio devices
aplay -l
aplay -L | grep :CARD
# produce noise on a device
speaker-test -D default:PCH -c 2
```
