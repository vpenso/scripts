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
```

Install the corresponding core to support the board

```bash
>>> arduino-cli core install arduino:avr
>>> arduino-cli core list
ID          Installed Latest Name
arduino:avr 1.8.2     1.8.2  Arduino AVR Boards
```

### Sketch


Create a new Sketch

```bash
arduino-cli sketch new blink
# creates a new sub-directory blink/ 
cat > blink/blink.ino <EOF
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
# compile the source code
arduino-cli compile --fqbn $fqbn blink
arduino-cli upload -p $port -b $fqbn blink
```
