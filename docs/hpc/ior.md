IOR (Interleaved or Random) file system benchmarking application 

<http://wiki.lustre.org/IOR>  
<https://github.com/LLNL/ior> (deprecated)  
<https://github.com/IOR-LANL/ior>  
<https://github.com/glennklockwood/ior-apex>

* Tests performance of parallel file-systems (like Lustre)
* Use MPI for process synchronisation
* Configurable to operate in multiple modes:
  - **File-per-process**: One file per task (measures peak throughput).
  - **Single-shared-file**: Single shared file for all tasks.
  - **Buffered**: Take advantage to I/O caches on the client.
  - **DirectIO**: Bypass I/O cache by writing directly to the file-system.

```bash
>>> git clone https://github.com/LLNL/ior.git && cd ior
>>> ./bootstrap
>>> ./configure
>>> make clean && make
```

Deploy the `ior` binary on all nodes used for benchmarking.

```bash
# 20 parallel task writing one file each with size 100MB 
mpirun -np 20 ior -a POSIX -vwk -t100m -b100m -i 10 -F -o ior.dat
```

### Options

File size (1.5x total main memory of a node):

    filesize = segmentCount * blocksize * number_of_processes

* `transfersize`: Size (in bytes) of a single data buffer to be transferred in a single I/O call. 
* `blocksize`:  Size (in bytes) of a contiguous chunk of data accessed by a single client
* `segmentCount`: Number of segments in file. (A segment is a contiguous chunk of **data accessed by multiple clients** each writing/reading their own contiguous data; comprised of blocks accessed by multiple clients or more transfers.)

### Configuration Files

```bash
>>> cat ior.conf    
IOR START
  api=MPIIO
  testFile=ior.dat
  repetitions=1
  readFile=1
  writeFile=1
  filePerProc=0
  keepFile=0
  blockSize=1024M
  transferSize=2M
  verbose=0
  numTasks=0
  collective=1
IOR STOP
>>> ior -f ior.conf
```

