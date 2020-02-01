PROJECT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
#
# - Compile the code with the `make` command
#
ARDUINO_DIR   = $(ARDUINO_HOME)
ARDMK_DIR     = /usr/share/arduino
ARDMK_PATH    = /usr/bin
AVR_TOOLS_DIR = $(ARDUINO_HOME)/hardware/tools/avr/

### Upload binary to the on-chip flash-memory
#
#   - Upload compiled program with `make upload`

AVRDUDE      = $(AVR_TOOLS_DIR)/bin/avrdude
AVRDUDE_CONF = $(AVR_TOOLS_DIR)/etc/avrdude.conf

# Type of board, cf. `make show_boards`
BOARD_TAG        = uno

### Access the serial console
#
#  - Display serial output from the Arduino with `make monitor`
#  - If auto detect of the baud rate does not work use MONITOR_BAUDRATE
#  - Exit with CTRL-A, SHIFT-K

MONITOR_BAUDRATE = 9600
MONITOR_PORT     = /dev/ttyACM0

### Path to where the your project's libraries are stored
#USER_LIB_PATH = $(PROJECT_DIR)/lib

# Add additional libraries
#
#   - Use a space separated list

ARDUINO_LIBS = SoftwareSerial

include $(ARDMK_DIR)/Arduino.mk
