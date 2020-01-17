**Storage**: a place to store data:

* **Cache**, on the CPU die
* **RAM**, close to CPU
* **SSD**, node internal, maybe part of an external storage system
* **Disk**, node internal, maybe part of an external storage system
* **Tape**, typically in a tape library

**Usable space** (~30% smaller than raw space):

* Raw space: Vendor information on the device, typically base 10 (e.g. 10TB)
* Usable space: Dependent on levels of redundancy and the file system, typically base 2 (e.g. 10TiB)

**Requirements**

* Total space required?
* Typical performance characteristics needed? (bandwidth per process/client)
* Distribution of files (size, count)?
* Typical I/O pattern, IOPs rate?
  - Transaction size read/write?
  - Sequential/streaming vs. random I/O?
* Write vs read ratio?
* Types of storage tiers?
  - Temporary scratch (days)?
  - Project online storage (month)?
  - Archive (disk, tape)?
  - Backups (snapshot, disk, tape)?
* Data transfer in-/out-going (size, bandwidth)?

# POSIX in HPC

POSIX I/O was designed for local storage (disks) with serial processors and workloads.

The **POSIX I/O API** defines how applications read/write data:

* Function calls for applications/libraries like `open()`, `close()`, `read()` and `write()`
* The **POSIX semantics** define what is guaranteed to happen with each API call
* E.g `write()` is **strongly consistent** and guaranteed to happen before any subsequent `read()`

POSIX I/O is **stateful**:

* **File descriptors** are central to this process
* The persistent state of data is maintained by tracking all file descriptors
* Typically the cost of **`open()` scales linearly** with the number of clients making a request

POSIX I/O prescribes a **specific set of metadata** that all files must possess:

* Metadata includes ownership, permissions, etc.
* Each file is treated independently, recursive changes are very costly
* The POSIX metadata schema at scales is difficult to support

Typically page cache is used to soften the latency penalty forced by POSIX consistency. Distributed storage can not efficiently use page cache since it is not shared among clients. Parallel file-systems may implement techniques like:

* No us of a page cache increasing the I/O latency for small writes
* Violate (or “relax”) POSIX consistency when clients modify non-overlapping parts of a file
* Implement a distributed lock mechanism to manage concurrency 

### Beyond POSIX

Large distributed applications are highly concurrent and often multi-tenant:

* POSIX was meant to provide a consistent view on data for (all) clients
* While storage systems are scaled, the time to sync data to guarantee consistency increases
* Applications can be dramatically slowed by bad I/O design (e.g. shared log-files, small I/O operations)
* Performance limits associated with **lock contention** force applications to a many-file I/O patterns

Highly scaleable distributed storage can not longer support the assumption that all 
applications look at the same view of the data. Short-term POSIX I/O may be optimized:

* **I/O needs to be engineered** like computer algorithms are profiled to improve performance
* Sophisticated implementation may reduce the **reduces the consistency domain** to a single client
* New layers in the I/O stack like **burst buffers** may improve efficiency of I/O in legacy applications

Long-term I/O needs to move away from POSIX (with consistent concurrent reads and writes):

* **Object base storage** requires data movement to be part of the application design
* "Lazy" data organization with directory trees suddenly disappears
* Performance optimizations of I/O patterns is required for each individual storage infrastructure

Eventually a distinction between read-only, write-only and read-write data is required.

* Most of the data should be read-only and immutable (after being written once) (write-once, read-many (WORM))
* Write-only data (e.g. checkpoints) data can be signed off when the writer has finished
* Data constantly in change (read-write) should live in a database

Cf:

* Intel **DAOS** (Distributed Application Object Storage)
* SAGE (Storage for Exascale)
