BLUETOOTHCTL_HELP="\
c                 controller state
cp [on|off]       controller power on
d                 device list
dc <dev>          connect to device
dd <dev>          disconnect from device
dp                paired devices
dr <dev>          remove device
s [on|off]        scan for devices
"

command -v bluetoothctl >&- && {


        function bluetoothctl-aliases() {
                local ex=bluetoothctl
                local command=$1
                [[ $# -ne 0 ]] && shift
                case "$command" in
                        d)      $ex info ;;
                        dc)     $ex connect $1 ;;
                        dd)     $ex disconnect $1 ;;
                        dp)     $ex paired-devices ;;
                        dr)     $ex remove $1 ;;
                        c)      $ex show ;;
                        cp)     $ex power ${1:-on} ;;
                        s)      $ex scan ${1:-on} ;;
                        *)      echo -n $BLUETOOTHCTL_HELP ;;
                esac
        }

        alias bt=bluetoothctl-aliases

}
