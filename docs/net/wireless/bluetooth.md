BlueZ [bluez] is the official Linux Bluetooth stack.

```bash
/etc/bluetooth/{input,main,network}.conf     # bluethoothd configuration
systemctl enable --now bluetooth             # start bluethoothd
bluetoothctl                                 # command line interface
```

Turn the physical Bluetooth device on/off with `rfkill`:

```bash
rfkill unblock bluetooth
rfkill block bluetooth
```

## Paring

The process of making two devices know about each other

- Exchange link-keys to secure the communication
- Can be initiated from both endpoints
- Includes an authentication that requires confirmation by the user

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

## Scan

```bash
bluetoothctl scan on
# stop as soon as the required device is reported
bluetoothctl scan off
```



### References 

[bluez] BlueZ - Bluetooth protocol stack for Linux  
http://www.bluez.org  
https://github.com/pauloborges/bluez
