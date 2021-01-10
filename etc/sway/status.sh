date=$(date +'%Y/%m/%d %H:%M')
upower=$(upower --show-info $(upower --enumerate | grep BAT) | egrep '(energy:|percentage)' | tr -d ' ' | cut -d: -f2 | tr '\n' ' ')

network=
for i in $(ip addr | awk '/state UP/ {print $2}' | sed 's/.$//')
do
        network="$i:$( ip addr show $i | grep 'inet ' | tr -s ' ' | cut -d' ' -f3)"
done

echo $network $upower $date
