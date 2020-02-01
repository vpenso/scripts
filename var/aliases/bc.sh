function dec2bin() {
  echo "0b$(echo "obase=2;ibase=10;${1:?Expecting decimal number}" | bc)"
}

function bin2dec() {
  echo "obase=10;ibase=2;${1:?Expecting binary number}" | bc
}

function bin2hex() {
  echo "0x$(echo "obase=16;ibase=2;${1:?Expecting binary number}" | bc)"
}

function hex2bin() {
  echo "0b$(echo "obase=2;ibase=16;${1:?Expecting hexa-decimal number}" | bc)"
}
