# Keyboard

Primary input device for humans.

Internal microcontroller operates the keyboard:

* Constantly scans the switches on the keyboard for a **keystroke**
* Keystroke starts with the user pressing a switch closing an electrical contact
* Typical switch settles down within 5 milliseconds, creating a **keybounce**
* Controller produces a single **scan code** compensating the bounce effect
* Down code on press and an up code on release are independent
* Supports holding a key down for Shift, Ctrl, Alt, etc. (modifiers)

Scancodes are send to the host operating system:

* Kernel maps scancodes to **keycodes**
* A keyboard layout maps a keycode to a symbol or **keysym**
* Symbol mapping depends on what **modifier keys** are hold

```bash
# list input devices
cat /proc/bus/input/devices | grep -P '^[NH]: ' | paste - -
# monitor keystrokes
evtest                      # select from the list of devices
evtest /dev/input/event$n   # select a specific device
# monitor keystrokes in a virtual console
showkey --keycodes
# monitor keystrokes in X
xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
# or
xbindkeys --defaults > ~/.xbindkeysrc
xbindkeys --multikey
```


