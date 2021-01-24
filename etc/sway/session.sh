#!/bin/sh

case "$1" in
        lock|l)
                ~/.config/sway/lock.sh
                ;;
        logout|g)
                swaymsg exit
                ;;
        suspend|s)
                lock & 
                sleep 2
                systemctl suspend
                ;;
        hibernate|h)
                lock &
                sleep 2
                systemctl hibernate
                ;;
        reboot|r)
                systemctl reboot
                ;;
        shutdown|s)
                systemctl poweroff
                ;;
        *)
                echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
                exit 2
esac

exit 0
