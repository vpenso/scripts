
##
# Route packages from specified interface (forward) to the 
# Internet using specified gateway interface (typically the 
# default gateway)
# 
# The host will practically act as a router receiving packets 
# from an interface and routing them towards their destination
#
# Forwarded packages pass the:
# 
#   PREROUTING    chain in table   nat
#   FORWARD       chain in table   filter
#   POSTROUTING   chain in table   nat
#
function ip-forward() {
        local forward=${1:?Specifiy interface to forward}
        local gateway=${2:?Specifiy default gateway interface}
        # enable IP forwarding in the kernel
        sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
        echo /proc/sys/net/ipv4/ip_forward $(cat /proc/sys/net/ipv4/ip_forward)
        # NAT all outbound traffic over the default gateway
        sudo iptables -t nat -A POSTROUTING -o $gateway -j MASQUERADE
        sudo iptables -t nat -L POSTROUTING -n -v
        # Forward traffic from a specified interface
        sudo iptables -A FORWARD -i $forward -j ACCEPT
        sudo iptables -L FORWARD -n -v
}
