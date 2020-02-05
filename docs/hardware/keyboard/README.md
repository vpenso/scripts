# Keyboard

Primary input device for humans.

Keyboards include control circuitry to convert key presses into **scancodes**:

* Constantly scans the switches on the keyboard for a **keystroke**
* Keystroke starts with the user pressing a switch closing a contact
* Typical switches settles within 5 milliseconds into firm contact
  - Key contacts "bounce" against each other for several milliseconds
  - Mechanical vibration cased by pressing the key
  - Release bounces again until they revert to the uncontacted state
* Controller produces a single scancode compensating the bounce effect
  - Typically called the **debounce** of a keystroke
  - Basically aggregating over time to produce one "confirmed" keystroke
  - Filtered by de-bounce circuit or in software
* Down code on press and an up code on release are independent
* Supports holding a key down for Shift, Ctrl, Alt, etc. (modifiers)

The keyboards sends the scancode to the keyboard driver running the host:

* Kernel maps scancodes to **keycodes**
* A keyboard layout maps a keycode to a symbol or **keysym**
* Symbol mapping depends on what **modifier keys** are hold

Mapping scancodes to keycodes is universal (not application specific)

## Connection Types

Several ways of connecting a keyboard to a host.

* Using cables
  - PS/2 IBM (1987) 6-pin mini-DIN connector replaced by...
  - **USB**, human-interface devices (HIDs)
  - USB-to-PS/2 adapter exist
* Wireless
  - Radio frequency (RF) or infrared (IR) replaced by...
  - **Bluetooth** radio communication
  - Vulnerable to signal theft, using a covert listening device in the same room


