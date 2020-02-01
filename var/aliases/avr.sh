export AVR_DEVICE=${AVR_DEVICE:-/dev/ttyACM0}
export AVR_MCU=atmega328p
export AVR_BAUDRATE=115200
export AVR_MONITOR_LOG=/tmp/monitor.log
export AVR_DUDECONF=$ARDUINO_HOME/hardware/tools/avr/etc/avrdude.conf

test "$_DEBUG" = true && {
        echo AVR_MONITOR_LOG=$AVR_MONITOR_LOG
        echo AVR_DEVICE=$AVR_DEVICE
        echo AVR_BAUDRATE=$AVR_BAUDRATE
}

function avr-upload() {
  local source=$1
  local name=$(basename $source)
  name=${name%%.*}
  local object=/tmp/$name.elf
  local hex=/tmp/$name.hex
  avr-gcc -mmcu=$AVR_MCU -o $object $source && \
  avr-objcopy -O ihex $object $hex && \
  avrdude -q -C $AVR_DUDECONF -p $AVR_MCU -c arduino -P $AVR_DEVICE -b $AVR_BAUDRATE -U flash:w:$hex:i
}

function avr-upload-nano() {
  AVR_DEVICE=/dev/ttyUSB0
  AVR_BAUDRATE=57600
  avr-upload $1
}

function avr-monitor() {
  minicom -D $AVR_DEVICE -b 9600 -C $AVR_MONITOR_LOG
}
