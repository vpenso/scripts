# 1.5" OLED RGB

Supports 4-wire and 3-wire SPI selected by the BS resistor on the backside 

4-wire SPI (Factory setting) BS set to 0:

Pin        | Description
-----------|--------------
VCC        | Power 3.3~5V
GND        | Ground
DIN        | Data Input, connect to MOSI
CLK        | Clock Data Input, connect to SCK
CS         | Chip Selection (low active)
DC         | 4-wire SPI Data/Command selection (high = data, low = command)
RST        | Reset (low active)

Dot matrix OLED controller **SSD1351**:

* 128x128 screen
* `128*128*128` SRAM display buffer
* 265k and 65k gray scale

## References

[w15or] Waveshare 1.5" OLED 128x128 RGB OLED  
https://www.waveshare.com/1.5inch-rgb-oled-module.htm

[ww15o] Waveshare Wiki 1.5" RGB OLED Module  
https://www.waveshare.com/wiki/1.5inch_RGB_OLED_Module

[w15um] Waveshare 1.5" RGB OLED User Manual  
https://www.waveshare.com/w/upload/5/5b/1.5inch_RGB_OLED_Module_User_Manual_EN.pdf

[ssdmd] Solomon Systech SSD1351 Dot Matrix Driver with Controller  
https://www.waveshare.com/w/upload/a/a7/SSD1351-Revision_1.5.pdf

[wexcg] Waveshare Example Code, Github  
https://github.com/waveshare/1.5inch-RGB-OLED-Module

[wwaec] Waveshare Wiki Arduino Example Code   
https://www.waveshare.com/wiki/File:1.5inch_OLED_Moudle.7z

[dbwod] Using OLED Displays with Arduino, DroneBot Workshop
https://dronebotworkshop.com/oled-arduino

[escoe] ESP32 SSD1351 1.5" Color OLED Example Code  
https://www.youtube.com/watch?v=sdcXBASJwMs  
https://github.com/G6EJD/ESP32-Connect-and-use-SSD1351-1.5-Colour-OLED

[lopdd] Luma.OLED Python Display Driver Library  
https://github.com/rm-hull/luma.oled

[apssd] Adafruit Python SSD1351 Library  
https://github.com/twchad/Adafruit_Python_SSD1351

[sodor] Small OLED Display on a rPi  
https://zedm.net/archives/589

[oqsgr] OLED128 QuickStart Guide - Raspberry Pi  
https://www.freetronics.com.au/pages/oled128-quickstart-guide-raspberry-pi

[urdwe] Using an RGB display with embedded C  
https://gecko05.github.io/2019/06/23/rgb-library.html  
https://github.com/Gecko05/SSD1351-Driver-Library
