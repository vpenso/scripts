# Open MPI (OMPI)

Main code sections:

* **OMPI** (Open MPI layer) the MPI API and supporting logic
* **ORTE** (Open MPI Run-Time Environment) interfaces the back-end run-time system
* **OPAL** (Open Portability Access Layer) utility code for the operating system

## Install

Download a release archive from the official web site: 

https://www.open-mpi.org/software/

```bash
## dependencies on CentOS
>>> yum groupinstall -y "Development Tools" && yum install bzip2
## select a target location for the installation
>>> prefix=$PWD/openmpi/2.1.1 && mkdir -p $prefix
## change into a scratch directory i.e. /tmp, download the archive and extract it
>>> wget https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.1.tar.bz2 && tar -xvf openmpi-2.1.1.tar.bz2
## make sure to have the required compilers (in a given version) in the shell enironment
>>> ./configure --prefix=$prefix 2>&1 | tee $prefix/configure.log
## adjust how many cores to use for the compilation with option -j
>>> make -j 8 2>&1 | tee $prefix/make.log
>>> make install 2>&1 | tee $prefix/install.log
## create a file to source this installation into a shell environment
>>> echo "export PATH=$prefix/bin:$PATH" >> $prefix/source_me.sh
>>> echo "export LD_LIBRARY_PATH=$prefix/lib:$LD_LIBRARY_PATH" >> $prefix/source_me.sh
>>> echo "export MANPATH=$prefix/share/man:$MANPATH" >> $prefix/source_me.sh
>>> source $prefix/source_me.sh
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
