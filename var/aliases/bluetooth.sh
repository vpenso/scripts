BLUETOOTHCTL_HELP="\
c                 controller state
cp [on|off]       controller power on
d                 list devices
p <dev>           pair device
dc <dev>          connect to device
dd <dev>          disconnect from device
dp                paired devices
dr <dev>          remove device
s  [sec]          scan for devices
"

command -v bluetoothctl >&- && {


        function bluetoothctl-aliases() {

                local ex=bluetoothctl

                # make sure the controller is on
                bluetoothctl power on |:

                local command=$1
                [[ $# -ne 0 ]] && shift
                case "$command" in
                        d)      $ex devices ;;
                        dc)     $ex connect $1 ;;
                        dd)     $ex disconnect $1 ;;
                        p)      $ex pair $1 ;;
                        dp)     $ex paired-devices ;;
                        dr)     $ex remove $1 ;;
                        c)      $ex show ;;
                        cp)     $ex power ${1:-on} ;;
                        s)      
                                {   
				    printf 'scan on\n\n'
				    sleep ${1:-10}
				    printf 'devices\n\n'
				    printf 'quit\n\n'
				} | bluetoothctl
                                ;;
                        *)      echo -n $BLUETOOTHCTL_HELP ;;
                esac

        }

        alias bt=bluetoothctl-aliases

}
