IOR (Interleaved or Random) file system benchmarking application 

<http://wiki.lustre.org/IOR>  
<https://github.com/LLNL/ior> (deprecated)  
<https://github.com/IOR-LANL/ior>

* Tests performance of parallel file-systems (like Lustre)
* Use MPI for process synchronisation

```bash
>>> git clone https://github.com/LLNL/ior.git && cd ior
>>> ./bootstrap
>>> ./configure
>>> make clean && make
```

Deploy the `ior` binary on all nodes used for benchmarking.

```bash
>>> ior -vwr -i 4 -F -o $PWD/test.dat -t 1m -b 1g
>>> ior -vwzFemk -i 4 -t 1m -b 128m -d 0.1 -a MPIIO -o ior.dat
```

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

### Options

File size (1.5x total memory of the system):

    filesize = segmentCount * blocksize * number_of_processes

* `transfersize`: Size (in bytes) of a single data buffer to be transferred in a single I/O call. 
* `blocksize`:  Size (in bytes) of a contiguous chunk of data accessed by a single client; it is comprised of one
* `segmentCount`: Number of segments in file. (A segment is a contiguous chunk of **data accessed by multiple clients** each writing/reading their own contiguous data; comprised of blocks accessed by multiple clients or more transfers.)

