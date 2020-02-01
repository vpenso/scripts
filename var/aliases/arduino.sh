# use the AVR tools distributed with the Arduino software
export PATH=$ARDUINO_HOME/hardware/tools/avr/bin:$PATH
export ARDUINO_FQBN=arduino:avr:uno

echo ARDUINO_HOME=$ARDUINO_HOME
echo ARDUINO_FQBN=$ARDUINO_FQBN

function arduino-upload() {
  $ARDUINO_HOME/arduino \
    --board $ARDUINO_FQBN \
    --port $AVR_DEVICE \
    --upload $@
}

function arduino-builder() {
  $ARDUINO_HOME/arduino-builder \
    -hardware $ARDUINO_HOME/hardware \
    -tools $ARDUINO_HOME/hardware/tools/avr \
    -tools $ARDUINO_HOME/tools-builder \
    -built-in-libraries $ARDUINO_HOME/libraries \
    -libraries $AVR_HOME/src/libraries \
    -build-path $AVR_HOME/build \
    -fqbn $ARDUINO_FQBN \
    $@
}
