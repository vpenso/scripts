Download a CoreOS Qcow2 virtual machine image file:

```bash
version=31.20200505.3.0
stream=stable
arch=x86_64
url=https://builds.coreos.fedoraproject.org/prod/streams/$stream/builds/$version/$arch
file=fedora-coreos-$version-qemu.$arch.qcow2
wget $url/$file.xz
# uncompress the archive
unxz $file
```

```bash
# Fedora CoreOS Configuration (FCC) in YAML
cat > example.fcc <<EOF
variant: fcos
version: 1.0.0
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - ssh-rsa AAAA...
EOF
# download the CoreOS Configuration Transpiler (fcct)
wget https://github.com/coreos/fcct/releases/download/v0.5.0/fcct-x86_64-unknown-linux-gnu -O fcct
chmod +x fcct
# convert the FCC file into an Ignition (JSON) file.
./fcct --pretty --strict < example.fcc > example.ign
```

```bash
virt-install \
      --name coreos --os-variant fedora-unknown \
      --ram 2048 --virt-type kvm --network bridge=nbr0 \
      --graphics=none --console pty,target_type=serial \
      --disk size=10,backing_store=$(realpath $file) --import \
      --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=$(realpath example.ign)"
```

## References

[fcogs] Fedora CoreOS - Getting Started  
<https://docs.fedoraproject.org/en-US/fedora-coreos/getting-started>  

[dfcos] Download Fedora CoreOS  
<https://getfedora.org/coreos/download?tab=metal_virtualized&stream=stable>

[fcpif] Fedora CoreOS - Producing an Ignition File  
<https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/>  
<https://docs.fedoraproject.org/en-US/fedora-coreos/fcct-config/>  
<https://github.com/coreos/fcct/releases>  
