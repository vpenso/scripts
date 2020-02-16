**Reset the device** in order to make sure that you start from a defined state:

1. Unplug the power supply cable
2. Hold the reset button (before powering the device)
3. Plug in the power supply
4. Wait until the green LED is flashing (before releasing the button)

This will force the load of the backup boot loader!

Connect your node to the device Ethernet **port 2** (the first port "Internet"
is in a different mode):

```bash
# login using an SSH client using the factory pre-configured IP-address/username
ssh admin@192.168.88.1
# no password will be required at first login
```
