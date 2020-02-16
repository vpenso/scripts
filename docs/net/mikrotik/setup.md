**Reset the device** in order to make sure that you start from a defined state:

1. Unplug the power supply cable
2. Hold the reset button (before powering the device)
3. Plug in the power supply
4. Wait until the green LED is flashing (before releasing the button)

This will force the load of the backup boot loader!

Depending on your setup scenario, make sure adjust the **routing metric** to
prioritise an interface with an outbound connection:

```bash
>>> grep -i metric /etc/systemd/network/*
/etc/systemd/network/20-wired.network:RouteMetric=10
/etc/systemd/network/25-wireless.network:RouteMetric=20
```

Connect your node to the device Ethernet **port 2** (the first port "Internet"
is in a different mode):

```bash
# login using an SSH client using the factory pre-configured IP-address/username
ssh admin@192.168.88.1
# no password will be required at first login
```

Lock down the device:

```bash
/user set admin password=1234567
# disable all service, except SSH
/ip service disable [find name!=ssh]
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
/tool bandwidth-server set enabled=no
/tool romon set enabled=no
# disable unused interfaces
/interface disable ether1,ether3,wlan1
```
