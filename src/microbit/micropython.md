# MicroPython

What is MicroPython? [micoy]

* Reimplementation of Python 3 for MCUs
  - Efficient with resources, runs on bare metal
  - Written in C++, includes compiler, run-time
  - REPL (read, evaluate, print loop)
* Compiler emitters...
  - Byte code for a virtual machine
  - Native machine code (x86, x64, ARM...)
  - Supports inline assembler

Micro:bit uses a pre-compiles run-time...

  - Runtime `.hex` flashed to the micro:bit
  - `.hex` contains complete MicroPython language

CicruitPython [cicpy] open source derivative of MicroPython

Install `uflash` [ulfmb]:

```shell
sudo apt install -y python3-pip
pip3 install uflash
# mount the device
pmount /dev/sdb MICROBIT
uflash $source
```

# References

[cicpy] CircuitPython, Adafruit  
<https://circuitpython.org/>  
<https://circuitpython.readthedocs.io>  
<https://github.com/adafruit/circuitpython>

[micpy] MicroPython  
<https://micropython.org>  
<http://docs.micropython.org>  
<https://github.com/micropython>

[mfsmb] MicroFS micro:bit command-line tool   
<https://github.com/ntoll/microfs>
<https://microfs.readthedocs.io/en/latest/>

[ulfmb] uFlash - Flash Python onto the BBC's micro:bit device  
<https://github.com/ntoll/uflash>
<https://uflash.readthedocs.io/en/latest/>

### Editors & IDEs

[mupye] Mu Python Editor  
<https://codewith.mu>

[mbwpy] micro:bit Web Python Editor  
<https://python.microbit.org>  
<https://python-editor-2-1-1.microbit.org/help.html>


### Workshops & Tutorials 

BBC micro:bit MicroPython documentation  
<https://microbit-micropython.readthedocs.io>  
<https://github.com/bbcmicrobit/micropython>

MicroPython for the Micro:bit Workshop, Core Electronics  
<https://www.youtube.com/playlist?list=PLPK2l9Knytg6SygFSODc3H1JL4KEm-Ruv>

Networking with the micro:bit Python Edition  
<https://microbit.nominetresearch.uk/networking-book-online-python/>

UCL’s BBC Micro:bit Tutorials  
<https://microbit-challenges.readthedocs.io>  
<https://github.com/rharbird/microbit-challenges>

Micro:bit Lessons - Introduction to cryptography  
https://microbit.org/lessons/cryptography>

Conway's Game of Life  
<https://www.hackster.io/ivo-ruaro/conway-s-game-of-life-e383e3>

BBC micro:bit – Tetris Game  
<https://www.101computing.net/bbc-microbit-tetris-game/>

micro:bit Space Invaders  
<https://www.mfitzp.com/article/microbit-space-invaders>

### Videos

Introduction to MicroPython, Arm Eduction  
<https://www.youtube.com/watch?v=XTSNznidJvU&list=PLXwAdcOl0lCpKRep_Gb_YVDfYjcaqZSvA>

MicroPython, Unexpected Maker  
<https://www.youtube.com/playlist?list=PL6F17pWypPy_KSmpnR5CV8x78QhAiKBIl>

MicroPython – Python for Microcontrollers, 35C3  
<https://www.youtube.com/watch?v=xCPnOxWxHIc>

MicroPython Basics: What is MicroPython?, Adafruit  
<https://www.youtube.com/watch?v=8btQWSu7DdM>

Writing fast and efficient MicroPython, Damien George (2018)  
<https://www.youtube.com/watch?v=hHec4qL00x0>

Extending MicroPython: Using C for good!, Matt Trentini (2019)  
<https://www.youtube.com/watch?v=437CZBnK8vI>
