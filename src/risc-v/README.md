## Buildroot


```bash
# download and extract Buildroot
wget https://buildroot.org/downloads/buildroot-2020.02.3.tar.gz
tar -xzf buildroot-2020.02.3.tar.gz
# change into the directory
# configure options described below
make menuconfig
# save, and exit 
make sdk
```

Configuration options:

* Target options > Target Architecture > RISCV
* Toolchain > C library > musl

### References

* [Embedded Linux from scratch in 40 minutes (on RiscV)][01], Michael
  Opdenacker. Bootlin
* [Buildroot for RISC-V Using Buildroot to create embedded Linux systems for
  64-bit RISC-V][02], Mark Corbin, FOSDEM 19


[01]: https://bootlin.com/pub/conferences/2019/cdl/opdenacker-embedded-linux-40minutes-riscv/opdenacker-embedded-linux-40minutes-riscv.pdf
[02]: https://www.youtube.com/watch?v=zizgRjTAYg8
