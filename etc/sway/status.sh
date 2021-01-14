date=$(date +'%Y/%m/%d %H:%M')

battery=$(upower --enumerate | grep BAT)
energy=$(upower --show-info $battery | grep energy: | cut -d: -f2 | xargs | tr -d ' ')
percent=$(upower --show-info $battery | grep percent | cut -d: -f2 | xargs)

ethernet=
wireless=
for i in $(ip addr | awk '/state UP/ {print $2}' | sed 's/.$//')
do
        case $i in
        enp*|eth*)
                ip=$( ip addr show $i | grep 'inet ' | tr -s ' ' | cut -d' ' -f3 )
                ethernet="$i | $ip"
                ;;
        wlan*)
                ip=$( ip addr show $i | grep 'inet ' | tr -s ' ' | cut -d' ' -f3 )
                essid=$( iwconfig wlan0 | head -n1 | cut -d: -f2 | tr -d '"' | xargs )
                signal=$( iwconfig wlan0 | grep Signal | cut -d= -f3 | tr -d ' ' )
                wireless="$i | $essid | $ip | $signal"
        ;;
        esac
done

kbd_layout=$(swaymsg -t get_inputs | grep -i 'active_layout_name' | uniq | cut -d'"' -f4)

echo "$ethernet $wireless -- $percent | $energy -- $kbd_layout | $date"
