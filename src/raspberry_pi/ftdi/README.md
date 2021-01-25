# FTDI

FTDI (Future Technology Devices International)

* Develops and manufactures devices converting RS-232, TTL serial transmissions to USB signals
* Prominent FT232RL [ft232] IC USB to UART converter

```shell
>>> lsusb | grep FT232
Bus 001 Device 004: ID 0403:6001 Future Technology Devices International, Ltd FT232 Serial (UART) IC
```

## Raspberry Pi 3 Mini UART

Uses`/dev/ttyS0` for Linux console output [piuar]:

* Make sure to jumper the logic level to **3.3V** 
* Enable the Linux console by adding `enable_uart=1` in `/boot/config.txt`

Default UART GPIO pins:

Pin | Description
----|------------
6   | GND (ground)
8   | TX (transmit)
10  | RX (receive)

![ftdi](ftdi.jpg)

Open a terminal and use Screen to the FTDI adapter:

```bash
screen /dev/ttyUSB0 115200
# exit with ctrl-a K
```


### Reference

[piuar] UART Configuration  
<https://www.raspberrypi.org/documentation/configuration/uart.md>

[ft232] FT232RQ USB 2.0 Slave to UART Converter  
<https://www.ftdichip.com/Products/ICs/FT232R.htm>

[tioty] tio - terminal application  
<https://github.com/tio/tio>

[dsdtc] DSD Tech  
<http://www.dsdtech-global.com>
<https://www.amazon.de/stores/DSD+TECH/page/66416B5E-8B05-426F-834D-0068ACCB6BD0>

Raspberry Pi 4, 3 and Zero W Serial Port Usage  
<https://di-marco.net/blog/it/2020-06-06-paspberry_pi_3_4_and_0_w_serial_port_usage/>
