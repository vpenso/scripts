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

## Keys Types

Most computer keyboards containe following keys:

* **Character keys**, core section of the keyboard
  - Three rows for typing **letters** `a-z` and punctuation `[]{};':",./<>?\|`
  - Upper row for typing **digits** `1234567890` and special symbols `~!@#$%^&*()_+-=`
  - The bottom row includes a **space bar** to enter a space
* **Modifier keys**  change the function of other keys
  - **Shift** alter the output of character keys (i.e. capitalize)
  - **Ctrl** (control) and **Alt** (alternate) trigger special functions
  - Modifier keys are typically used together with other keys
  - **AltGr** secondary shift key (in place of the right Alt key)
  - **Caps Lock** toggle key to capitalizes `A-Z`
* **Navigation Keys**
  - **Arrow Keys** to navigate with the text cursor
  - Page Up/Down used to scroll up or down in documents
  - `Home` and `End` used to return to the beginning/end of the document
* **Function keys** `F1` up to `F12`
* **Dead keys** special modifier keys not generating a character itself
  - Pressed an released before other keys to modify the subsequent key press
  - I.e. to type letters with grave accent like `à`
* **Compose key** is a generic dead key
  - Allows interpreting whole sequences of keystrokes
  - I.e. to type acute accent `á` using `'` (apostrophe)
