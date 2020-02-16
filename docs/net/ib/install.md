
## Install

Official Mellanox [Linux Drivers](http://www.mellanox.com/page/products_dyn?product_family=26&mtag=linux_sw_drivers)

Kernel drivers are required to operate the host channel adapter. 

CentOS:

```bash
yum install -y libibverbs librdmacm libibcm libibmad libibumad libmlx4 libmlx5 opensm ibutils infiniband-diags srptools perftest mstflint rdmacm-utils ibverbs-utils librdmacm-utils 
/etc/rdma/rdma.conf                      # configuration file
systemctl enable --now rdma.service      # enable Infinibnand
```

Packages:

```
rdma-core               # RDMA core userspace libraries and daemons
rdma-core-devel
libibverbs              # InfiniBand Verbs API
libibverbs-utils
libfabric               # User-space RDMA Fabric Interfaces
librdmacm               # Userspace RDMA Connection Manager
librdmacm-util
libibcommon             # OFED common library
libibcommon-static
libibcommon-devel
libibmad                # OFED MAD library
libibmad-static
libibmad-devel
libibumad               # OFED umad (userspace management)
opensm                  # Subnet manager
```
 


Debian

```bash
# jessie
apt install -y libmlx4-1 libibcommon1 libibmad1 libibumad1 libopensm2 infiniband-diags ibutils ofa-kernel-modules
```

## Kernel Modules

Mellanox HCAs require at least the `mlx?_core` and `mlx?_ib` kernel modules. 

* `mlx4_*` modules are use by **ConnectX** adapters, and `mlx5_*` modules are used by **Connect-IB** adapters.
* The "core" module is a generic driver use by `mlx_[ib|en|fc]` for Infiniband, Ethernet, or Fiber-Channel support.
* The "ib" module contains Infiniband specific functions.

```bash
## find all infiniband modules
>>> find /lib/modules/$(uname -r)/kernel/drivers/infiniband -type f -name \*.ko
## load requried modules
>>> for mod in mlx4_core mlx4_ib ib_umad ib_ipoib rdma_ucm ; do modprobe $mod ; done
## make sure modules get loaded on boot 
>>> for mod in mlx4_core mlx4_ib ib_umad ib_ipoib rdma_ucm ; do echo "$mod" >> /etc/modules-load.d/infiniband.conf ; done
## list loaded infiniband modules
>>> lsmod | egrep "^mlx|^ib|^rdma"
## check the version
>>> modinfo mlx4_core | grep -e ^filename -e ^version
## list module configuration parameters
>>> for i in /sys/module/mlx?_core/parameters/* ; do echo $i: $(cat $i); done
## module configuration
>>> cat /etc/modprobe.d/mlx4_core.conf
options mlx4_core log_num_mtt=20 log_mtts_per_seg=4
```
