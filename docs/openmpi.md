# Open MPI (OMPI)

Main code sections:

* **OMPI** (Open MPI layer) the MPI API and supporting logic
* **ORTE** (Open MPI Run-Time Environment) interfaces the back-end run-time system
* **OPAL** (Open Portability Access Layer) utility code for the operating system

## Install


### Packages

Debian Stretch supports OpenMPI 2.0:

```bash
>>> apt install openmpi-bin libopenmpi-dev openmpi-doc
```


### From Source

Developing version on GitHub:

<https://github.com/open-mpi/ompi/releases>

Official source-code archive:

<https://www.open-mpi.org/software/>

```bash
# download the latest archive and extract it
>>> wget https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-3.0.0.tar.gz
>>> tar -xvf openmpi-3.0.0.tar.gz && cd openmpi-3.0.0
## select a target location for the installation
>>> prefix=$PWD/openmpi/3.0.0 && mkdir -p $prefix
## make sure to have the required compilers (in a given version) in the shell enironment
>>> ./configure --prefix=$prefix 2>&1 | tee $prefix/configure.log
## adjust how many cores to use for the compilation with option -j
>>> make -j $(nprocs) 2>&1 | tee $prefix/make.log
>>> make install 2>&1 | tee $prefix/install.log
>>> cp -R examples $prefix
## create a file to source this installation into a shell environment
>>> echo "export PATH=$prefix/bin:$PATH" >> $prefix/source_me.sh
>>> echo "export LD_LIBRARY_PATH=$prefix/lib:$LD_LIBRARY_PATH" >> $prefix/source_me.sh
>>> echo "export MANPATH=$prefix/share/man:$MANPATH" >> $prefix/source_me.sh
>>> source $prefix/source_me.sh
```

### RPM Packages

Build RPM packages by following the [README](https://github.com/open-mpi/ompi/tree/v3.0.x/contrib/dist/linux)

* Download the latest SRPM for a given MPI version

```bash
>>> yum groupinstall -y "Development Tools"
# infiniband
>>> yum install -y libibverbs librdmacm libibcm libibmad libibumad libmlx4 libmlx5 librdmacm-utils
# NUMA support, CPU affinity support
>>> yum install -y numactl-devel hwloc-devel
>>> wget https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-3.0.0-1.src.rpm
>>> rpmbuild --rebuild openmpi-3.0.0-1.src.rpm
>>> ls ~/rpmbuild/RPMS/x86_64/openmpi*.rpm
/root/rpmbuild/RPMS/x86_64/openmpi-3.0.0-1.el7.centos.x86_64.rpm
# install the package and check the configuration
>>> rpm -i ~/rpmbuild/RPMS/x86_64/openmpi*.rpm
>>> ompi_info --param all all --level 9
```

## Usage

Following a simple Open MPI example program `hello_world.c`: 

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include "mpi.h"

/*
Aim:

  Print the "Hello World" message from each process spaned, including
  the process ID from the operating system and the MPI rank.

Note:

  Processes are represented by a unique "rank" (integer) and ranks are 
  numbered 0, 1, 2, ..., N-1. 

  MPI_COMM_WORLD means "all the processes in the MPI application." It 
  is called a communicator and it provides all information necessary to 
  do message passing.

*/
int main(int argc,char ** argv )
{
    // Rank of the calling process in the communicator group
    int rank;
    // Total number of processes in the communicator group
    int size;
    // Hostname
    char hostname[1024];

    // Initialize the MPI execution environment 
    MPI_Init( &argc, &argv );
    // MPI_COMM_WORLD is the default communicator setup by MPI_Init()  

    /* 
    Typically, a process in a parallel application needs to know who 
    it is (its rank) and how many other processes exist. A process 
    finds out its own rank by calling MPI_Comm_rank() and the total 
    number of processes is returned by MPI_Comm_size().
    */
    MPI_Comm_rank( MPI_COMM_WORLD, &rank );
    MPI_Comm_size( MPI_COMM_WORLD, &size );

    // Get the process ID from the OS
    pid_t pid = getpid();
    // Get the hostname
    gethostname(hostname, 1024);

    printf( "Hello world %s.%d [%d/%d]\n",hostname , pid, rank, size);

    // Terminates MPI execution environment and clean up the process
    MPI_Finalize();

    return 0;
}
```

Cf. [Official OMPI Examples](https://github.com/open-mpi/ompi/tree/master/examples)

Compile the using `mpicc` an execute it locally with `mpirun`:

```bash
>>> mpicc -o hello_world hello_world.c
>>> mpirun -np 4 hello_world              # run with 4 processes
```

### MCA Parameters

Change the behavior of code at run-time in following precedence:

1. Command line arguments `mpirun -mca <name> <value>`
2. Environment variables `export OMPI_MCA_<name>=<value>`
3. Files i.e. `$HOME/.openmpi/mca‐params.conf`
4. Default value

Use `ompi_info` to investigate the OMPI installation

```bash
ompi_info --param btl all       # show the BTL (Byte Transfer Layer) supported        
```

Cf. [Open MPI FAQ: General run-time tuning](https://www.open-mpi.org/faq/?category=tuning)
