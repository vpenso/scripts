
## 1602 LCD Module

![](1602-LCD_monochrom.jpg)

 Pin   | Name          | Description
-------|---------------|-------------------------------------------------
 #1    | **VSS**       | Ground **0V**
 #2    | **VDD**       | Logic power **+5V**
 #3    | **VO**        | Display contrast
 #4    | **RS**        | Register select (data or instruction register)
 #5    | **RW**        | Read (high), Write (low)
 #6    | **E**         | Enable signal for data write or read
 #7-14 | **D0**-**D7** | 8bit bi-directional data bus
 #15   | **A**         | Backlight power +5V
 #16   | **K**         | Backlight ground 0V

* Display format 16 characters by 2 lines, display font 5x8 dots
* Logic voltage 4.8-5.2V, max 150mA
* Supports 4bit (D4-D7) and 8bit (D0-D7) data operations

[spec] Specification for LCD Module 1602A-1  
https://www.openhacks.com/uploadsproductos/eone-1602a1.pdf
