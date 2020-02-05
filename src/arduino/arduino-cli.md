# Arduino CLI

<https://github.com/arduino/arduino-cli>

Download the latest version from the [releases page][aclir]:

[aclir]: https://github.com/arduino/arduino-cli/releases

```bash
cd /tmp
wget https://github.com/arduino/arduino-cli/releases/download/0.7.2/arduino-cli_0.7.2_Linux_64bit.tar.gz
tar -xvf arduino-cli_0.7.2_Linux_64bit.tar.gz
sudo mv arduino-cli /usr/local/bin
```

Update the local cache of available **platforms and libraries**:

```bash
arduino-cli core update-index
```

## Usage

### Cores

Connect a board via an USB cable:

```bash
# list connected boards
>>> arduino-cli board list
Port         Type              Board Name  FQBN            Core
/dev/ttyACM0 Serial Port (USB) Arduino Uno arduino:avr:uno arduino:avr
/dev/ttyAMA0 Serial Port       Unknown
/dev/ttyUSB0 Serial Port (USB) Unknown
```

`Unknown` boards should work as long you identify the platform core and use the
correct FQBN string

Install the corresponding core to support the board

```bash
>>> arduino-cli core install arduino:avr
>>> arduino-cli core list
ID          Installed Latest Name
arduino:avr 1.8.2     1.8.2  Arduino AVR Boards
# search for a supported board
>>> arduino-cli board listall nano
Board Name   FQBN
Arduino Nano arduino:avr:nano
```

### Sketch


Create a new Sketch

```bash
arduino-cli sketch new blink
# creates a new sub-directory blink/ 
cat > blink/blink.ino <<EOF
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}
EOF
```

```bash
fqbn=arduino:avr:uno
port=/dev/ttyACM0
# build and flash for an Arduino Uno
arduino-cli compile --fqbn arduino:avr:uno blink
arduino-cli upload -p /dev/ttyACM0 -b arduino:avr:uno blink
# build and flash for an Arduino Nano
arduino-cli compile -b arduino:avr:nano blink
```
