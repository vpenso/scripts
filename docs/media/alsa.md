# ALSA (Advanced Linux Sound Architecture) 

Full audio and MIDI functionality for Linux

* Kernel sound card drivers since Linux 2.6 (1998)
* User space driven library for application developers
* Optional OSS emulation mode for `/dev/sound`, `/dev/dsp`, etc
* Device files in `/dev/snd/` (use alsa-lib instead)

```bash
sudo apt install -y alsa-utils
# kernel messages for sound devices
sudo dmesg | egrep -i "alsa|snd"  
# verify that sound modules are loaded
lsmod | grep '^snd' | column -t
```

## Configuration

`/proc/asound` kernel interface

```bash
/proc/asound/version              # ALSA version
/proc/asound/cards                # list of registered cards
# PCM device-related information and status
tail -n+2 /proc/asound/card[0-9]/pcm*/info
```
```bash
# list of registered ALSA devices
>>> cat /proc/asound/devices
  2: [ 0- 0]: digital audio playback
  3: [ 0- 0]: digital audio capture
  4: [ 0- 3]: digital audio playback
  5: [ 0- 7]: digital audio playback
  6: [ 0- 8]: digital audio playback
  7: [ 0- 9]: digital audio playback
  8: [ 0-10]: digital audio playback
  9: [ 0- 0]: hardware dependent
 10: [ 0- 2]: hardware dependent
 11: [ 0]   : control
 33:        : timer
  |    |  |
  |    |  `- device number
  |    `---- card number
  `--------- minor number
```


ALSA library configuration:

```
/usr/share/alsa/alsa.conf
/etc/asound.conf
~/.asoundrc
```

Save settings (volume states) for device:

```bash
alsactl store      # store alsamixer confguration
alsactl restore    # restores the saved alsamixer state
```

## Usage

Users have permission to play audio and change mixer levels:

```bash
amixer                            # configure audio settings
alsamixer                         # ..using a TUI
# list audio devices
aplay -l
aplay -L | grep :CARD
# produce noise on a device
speaker-test -D default:PCH -c 2
```

Keyboard volume control:

```bash
amixer set Master 5%+      # increase volume
amixer set Master 5%-      # decrease volume
amixer set Master toggle   # toggle mute
```

