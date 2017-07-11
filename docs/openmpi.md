
Download an OpenMPI release archive from: 

https://www.open-mpi.org/software/

```bash
## select a target location for the installation
>>> prefix=$PWD/openmpi/2.1.1 && mkdir -p $prefix
## change into a scratch directory i.e. /tmp
>>> wget https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.1.tar.bz2 && tar -xvf openmpi-2.1.1.tar.bz2
## make sure to have the required compilers (in a given version) in the shell enironment
>>> ./configure --prefix=$prefix | tee $prefix/configure.log
## adjust how many cores to use for the compilation
>>> make -j 8 | tee $prefix/make.log
>>> make install | tee $prefix/install.log
## create a file to source this installation into a shell environment
>>> echo "export PATH=$prefix/bin:$PATH" >> $prefix/source_me.sh
>>> echo "export LD_LIBRARY_PATH=$prefix/lib:$LD_LIBRARY_PATH" >> $prefix/source_me.sh
>>> source $prefix/source_me.sh
```

## Usage

Following a simple OpenMPI example program `hello_world.c`: 

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

Compile the program an execute it locally:

```bash
>>> mpicc -o hello_world hello_world.c
>>> mpirun -np 4 hello_world
```
