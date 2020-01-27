# Pulseaudio

```bash
sudo apt install -y pulseaudio pulsemixer pavucontrol
```

```bash
pulseaudio -vvvvv                # start in foreground with debugging
pulseaudio -k                    # kill running server
pulseaudio -D                    # start as daemon
pacmd ls                         # show audio system state
pulsemixer                       # curses base volume control/mixer
pavucontrol                      # GTK based volume control/mixer
```

```bash
# input sources (* indicates current default)
pacmd list-sources | grep -e 'index:' -e device.string -e 'name:'
# output sources
pacmd list-sinks | grep -e 'name:' -e 'index:'
```

## References

[pauth] PulseAudio under the hood (2017)  
https://gavv.github.io/articles/pulseaudio-under-the-hood/
