function lssrl () {
        # find serial USB devices
        find /dev -name 'ttyACM*' -o -name 'ttyUSB*' | xargs stat --printf "%n %G\n"
}
