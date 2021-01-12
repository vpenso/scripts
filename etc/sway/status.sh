date=$(date +'%Y/%m/%d %H:%M')
upower=$(upower --show-info $(upower --enumerate | grep BAT) | egrep '(energy:|percentage)' | tr -d ' ' | cut -d: -f2 | tr '\n' ' ')

ethernet=
wireless=
for i in $(ip addr | awk '/state UP/ {print $2}' | sed 's/.$//')
do
        case $i in
        enp*|eth*)
                ip=$( ip addr show $i | grep 'inet ' | tr -s ' ' | cut -d' ' -f3 )
                ethernet=$i:$ip
                ;;
        wlan*)
                ip=$( ip addr show $i | grep 'inet ' | tr -s ' ' | cut -d' ' -f3 )
                essid=$( iwconfig wlan0 | head -n1 | cut -d: -f2 | tr -d '"' | xargs )
                signal=$( iwconfig wlan0 | grep Signal | cut -d= -f3 | tr -d ' ' )
                wireless="$i:$essid:$ip:$signal"
        ;;
        esac
done

echo "$ethernet $wireless | $upower $date"
