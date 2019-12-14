```bash
sudo apt install -y connman
```

## Usage

```bash
/etc/connman/main.conf                # configuration file
systemctl ... connman                 # service managment
/var/lib/connman/                     # profile settings
connmanctl enable wifi                # power Wi-Fi on
           disable wifi
           scan wifi                  # scan for WLAN networks
```

Establish your first connection with an interactive session:

```bash
connmanctl
connmanctl> agent on
# scan for access points (AP)
connmanctl> scan wifi
# show available APs
connmanctl> services
*A  ..--WAVENET--..      wifi_185e0f65e843_2e2e2d2d574156454e45542d2d2e2e_managed_psk
# leading asterisk indicates a previously used AP
# connect to an AP
connmanctl> connect wifi_185e0f65e843_2e2e2d2d574156454e45542d2d2e2e_managed_psk
# disconnect
connmanctl> quit
```

After authorisation with the AP has been established:

```bash
connmanctl services
connmanctl connect ...
```
