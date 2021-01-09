## NetworkManager

```bash
nmcli device status
nmcli con mod $device connection.autoconnect yes
```

GNOME NetworkManager configures and monitors Wifi network connections [1]:

```bash
nmcli radio wifi on|off                 # toggle Wifi
nmcli dev wifi                          # list available Wifi APs
```

Connect to Wifi using the **NetworkManager applet** [2].

Start the applet on session it within the **i3 Window Manager**:

```bash
# start NetworkManager applet
exec_always --no-startup-id nm-applet
```

# References

[1] GNOME Network Manager  
https://wiki.gnome.org/Projects/NetworkManager/

[2] NetworkManager Gnome Applet  
https://gitlab.gnome.org/GNOME/network-manager-applet
