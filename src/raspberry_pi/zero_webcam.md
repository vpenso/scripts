
Raspberry Pi HQ Camera [[rphqc]

* Supports CS- and C-mount (with adapter) lenses
* Tripod mount: 1/4”-20
* Pi Zero requires a specific ribbon cable

Linux UVC driver [lxuvc]

* USB Video [device] Class (UVC)
  - USB specification to standardize video streaming over USB
  - Utilized for  webcams, camcorders, video converters, digital television
* Implements the Video4Linux 2 (V4L2) API.
* Linux USB gadget [lxgcc]
  - Device using UVC (on a USB slave controller)
  - Kernel modules that represent a USB devices 

### References

[lxuvc] Linux UVC driver  
<http://www.ideasonboard.org/uvc/>

[lxgcc] Linux USB gadget configured through configfs  
<https://www.kernel.org/doc/html/v5.4/usb/gadget_configfs.html>

[cugrp] Composite USB Gadgets on the Raspberry Pi Zero  
<http://www.isticktoit.net/?p=1383>

[rpcpc] Raspberry Pi Zero with Pi Camera as USB Webcam  
<http://www.davidhunt.ie/raspberry-pi-zero-with-pi-camera-as-usb-webcam/>

[rpiwc] Raspberry Pi Webcam  
<https://github.com/geerlingguy/pi-webcam>
<https://www.youtube.com/watch?v=8fcbP7lEdzY>

[rphqc] Raspberry Pi High Quality Camera  
<https://www.raspberrypi.org/products/raspberry-pi-high-quality-camera/>  

[babuw] Build a Better USB Webcam!  
<https://www.youtube.com/watch?v=x_4XuQ0JgQo>
