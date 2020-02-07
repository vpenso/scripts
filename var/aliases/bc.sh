dec2bin() {
  echo "0b$(echo "obase=2;ibase=10;${1:?Expecting decimal number}" | bc)"
}

dec2hex() {
        local dec=${1:?Expecting decimal number}
        echo "obase=16;ibase=10;$dec" | bc
}

bin2dec() {
  echo "obase=10;ibase=2;${1:?Expecting binary number}" | bc
}

bin2hex() {
  echo "0x$(echo "obase=16;ibase=2;${1:?Expecting binary number}" | bc)"
}

hex2bin() {
        local hex=${1:?Expecting hexa-decimal number}
        # convert to uppercase
        hex=$(echo $hex | tr '[a-f]' '[A-F]')
        # calculate binary value
        bin=$(echo "obase=2;ibase=16;$hex" | bc)
        echo "0b$bin"
}

hex2dec() {
        local hex=${1:?Expecting hexa-decimal number}
        # convert to uppercase
        hex=$(echo $hex | tr '[a-f]' '[A-F]')
        echo "obase=10;ibase=16;$hex" | bc
}
