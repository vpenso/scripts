`iwd` (iNet wireless daemon) aims to replace WPA supplicant

- No external dependencies, base on kernel features (D-Bus, cryptographic interface)
- Designed to deal with multiple clients from the outset
- Can be combined with systemd-networkd

## Build

Depending on the Linux distribution, update `iwd` to a recent version:

```bash
# print version information
/usr/libexec/iwd --version
```

Build `iwd` from source code [iwdsrc], and install it:

```bash
tmp=$(mktemp -d) && cd $tmp
# dependencies on Debian
sudo apt install -y libtool libreadline-dev libdbus-glib-1-dev
# download the required source code
git clone https://kernel.googlesource.com/pub/scm/libs/ell/ell.git
# It is not required to build or install Embedded Linux library
git clone git://git.kernel.org/pub/scm/network/wireless/iwd.git && cd iwd
# configure, build, and install
./bootstrap
./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc
make
sudo make install
rm -rf $tmp
# load the systemd configuration
sudo systemctl daemon-reload
```

## Usage

Make sure to configure following prerequisites:

1. Bring up the interfaces with `systemd-networkd`
2. Configure DNS resolution with `systemd-resolved`

Minimal configuration to assign IP address(es) and set up routes using a
built-in DHCP client:

```bash
cat > /etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=true
EOF
# Enable the service to manage Wifi connections automatically
sudo systemctl enable --now iwd           
```

In case you want to debug connection problems, start `iwd` in foreground:

```bash
# locate the service executable
systemctl cat iwd.service | grep ExecStart
ExecStart=/usr/libexec/iwd
# run in foreground with debug mode 
sudo IWD_TLS_DEBUG=1 /usr/libexec/iwd -d
```

Use the command-line interface `iwctl` to select a WiFi connection:

```bash
iwctl device list                    # list wireless devices
iwctl device <dev> show              # show device details
iwctl station list                   # list state
iwctl station <dev> scan             # scan for networks
iwctl station <dev> get-networks     # list networks
iwctl station <dev> connect <ssid>   # connect to network
```

## Configuration

Access point connection configuration is store:

* `iwd` monitors the directory for changes.
* Cf. manual page `iwd.network`

```bash
/var/lib/iwd/*.{open,psk,8021x}      # network configuration files
```

Configure the **DNS resolution**:

```bash
[Network]
NameResolvingService=resolvconf
# systemd is used by default
```

### WPA2

The PreSharedKey can be calculated with `wpa_passphrase` (from wpa_supplicant)
from the SSID and the WIFI passphrase:

```bash
>>> wpa_passphrase <ssid>
# reading passphrase from stdin
************
network={
    ssid="<ssid>"
    #psk="***********"
    psk=9d1c20628cabdb224a1a420723478f585f4579efd4b206301b8c0d6e5ddc8296
}

```
```bash
cat > /var/lib/iwd/<ssid>.psk <<EOF
[Security]
PreSharedKey=9d1c20628cabdb224a1a420723478f585f4579efd4b206301b8c0d6e5ddc8296
EOF
```

### Eduroam

**This is currently not working!**

Connect to [eduroam](https://www.eduroam.org/) using `iwd`

```bash
ca=https://www.pki.dfn.de/fileadmin/PKI/zertifikate/T-TeleSec_GlobalRoot_Class_2.crt
sudo wget -q $ca -O /var/lib/iwd/eduroam.cer
openssl x509 -inform DER \
             -in /var/lib/iwd/eduroam.cer \
             -out /var/lib/iwd/eduroam.crt
```

Create a configuration to access Eduroam

```bash
domain=devops.test
user=devops
password=12345678
cat << EOF | sudo tee /var/lib/iwd/eduroam.8021x
[Settings]
AutoConnect=true

[Security]
EAP-Method=PEAP
EAP-Identity=anonymous@${domain}
EAP-PEAP-CACert=/var/lib/iwd/eduroam.crt
EAP-PEAP-ServerDomainMask=radius.${domain}
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=${user}@${domain}
EAP-PEAP-Phase2-Password=${password}
EOF
```


## References

[iwdwiki] Wiki Documentation  
https://iwd.wiki.kernel.org/start

[iwdconf] Configuration File Format  
https://iwd.wiki.kernel.org/networkconfigurationsettings

[iwdsrc] Source Code Repository  
https://git.kernel.org/pub/scm/network/wireless/iwd.git/

[archdoc] Documentation in the ArchLinux Wiki  
https://wiki.archlinux.org/index.php/Iwd
