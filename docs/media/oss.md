## OSS (Open Sound System)
 
Old sound card support system up to Linux 2.4

* Still used for old sound cards not ported to ALSA, marked as deprecated
* Designed for standard devices system calls `read()`, `write()`, etc.
* Write to `/dev/dsp` for playback
* Reading from `/dev/dsp` to capture (recorde)

```
/dev/dsp        # D/A and A/D converter device, generate/read audio
/dev/mixer      # mainly for controlling volume
/dev/audio      # Sun compatible digital audio
/dev/sequencer  # audio sequencer (MIDI)
```

Limitations:

* No support for software mixing (limited to a single application)
* Play/record at the same time not possible
* No hardware MIDI support
