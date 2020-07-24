## Buildroot

Build the cross-compilation toolchain for RISC-V:

<https://buildroot.org/downloads/manual/manual.html#configure>

```bash
# download and extract Buildroot
wget https://buildroot.org/downloads/buildroot-2020.02.3.tar.gz
tar -xzf buildroot-2020.02.3.tar.gz # change into the directory
# Configure the target platform
#   Target options > Target Architecture > RISCV
#   Toolchain > C library > musl
#   Host utilities > host qemu
make menuconfig # save, exit
# build the cross-compilation toolchain
make sdk
```

Install the cross-compilation toolchain used to generates code for your target
system (and target processor):

```bash
mkdir $HOME/toolchain
cp output/images/riscv64-buildroot-linux-musl_sdk-buildroot.tar.gz $HOME/toolchain/
cd $HOME/toolchain
tar -xzf riscv64-buildroot-linux-musl_sdk-buildroot.tar.gz
cd riscv64-buildroot-linux-musl_sdk-buildroot
./relocate-sdk.sh
# create a file used to source the environment
cat <<"EOF" >riscv64-env.sh
export PATH=$HOME/toolchain/riscv64-buildroot-linux-musl_sdk-buildroot/bin:$PATH
EOF
source riscv64-env.sh
```

Test the tool chain:

```bash
# create a simple hello world program
cat <<EOF >hello.c
#include <stdio.h>
int main() { printf("Hello, World!"); return 0; }
EOF
# compile the program
riscv64-linux-gcc -static -o hello hello.c
# execute the binary
qemu-riscv64 hello
```


### References

* [Embedded Linux from scratch in 40 minutes (on RiscV)][01], Michael
  Opdenacker. Bootlin
* [Buildroot for RISC-V Using Buildroot to create embedded Linux systems for
  64-bit RISC-V][02], Mark Corbin, FOSDEM 19


[01]: https://bootlin.com/pub/conferences/2019/cdl/opdenacker-embedded-linux-40minutes-riscv/opdenacker-embedded-linux-40minutes-riscv.pdf
[02]: https://www.youtube.com/watch?v=zizgRjTAYg8
