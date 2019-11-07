# Bluetooth

## Install

BlueZ [bluez] is the official Linux Bluetooth stack.

```bash
/etc/bluetooth/{input,main,network}.conf     # bluethoothd configuration
systemctl enable --now bluetooth             # start bluethoothd
journalctl -u bluetooth                      # bluethoothd logs
bluetoothctl                                 # command line interface
```

Turn the physical Bluetooth device on/off with `rfkill`:

```bash
rfkill unblock bluetooth
rfkill block bluetooth
```

### A2DP

`bluetoothd` emits an error like to following if support for audio streaming is
not installed:

```
a2dp-sink profile connect failed for ... Protocol not available
```

> A2DP is the "Advanced Audio Distribution Profile" which describes how 
> Bluetooth devices can stream stereo-quality audio to remote devices. 

Install the additional `pulseaudio-bluetooth` package:

```bash
sudo apt install -y pulseaudio pulseaudio-module-bluetooth bluez-firmware
sudo systemctl restart bluetooth
pulseaudio --kill && pulseaudio --start
```

## Usage

**Pairing** is the process of making two devices know about each other

- Exchange link-keys to secure the communication
- Can be initiated from both endpoints
- Includes an authentication that requires confirmation by the user

Outbound pairing & connection:

```bash
bluetoothctl scan on     # wait until devices are discovered
bluetoothctl devices     # list found device MAC address and name
bluetoothctl agent on    # start an authentication agend
bluetoothctl pair $mac   # pair with a device
# after paring connect to the device
```

Inbound pairing:

```bash
# make the device discoverable and pairable
bluetoothctl discoverable on
bluetoothctl pairable on
```

An agent may be used to guide interactive device paring. Register an agent 
BlueZ service with:

```bash
bluetoothctl agent KeyboardOnly
```

If no agent is registered paring will be attempted without user interaction




### References 

[bluez] BlueZ - Bluetooth protocol stack for Linux  
http://www.bluez.org  
https://github.com/pauloborges/bluez
