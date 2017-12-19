# POSIX

The POSIX I/O API defines how applications read/write data:

* Provides function calls for application and libraries like `open()`, `close()`, `read()` and `write()`
* The POSIX **semantics** define what is guaranteed to happen with each API call.

POSIX I/O is **stateful**:

* **File descriptors** are central to this process
* The persistent state of data is maintained by tracking the all file descriptors
* Typically the cost of **`open()` scales linearly** with the number of clients making a request

POSIX I/O prescribes a **specific set of metadata** that all files must possess:

* Metadata includes ownership, permissions, etc.
* POSIX metadata schema at scales is difficult to support
* Each file is treated independently, recursive changes are very costly

# Beyond POSIX

POSIX I/O was designed at its time with local (disk based) storage:

* Its implementation was meant to provide a consistent view on data for (all) applications
* While storage systems are scaled, the time to sync data increases (distributed locks)
* Highly scaleable distributed storage can not longer support the assumption that all applications look at the same view of the data

I/O needs to be engineered like computer algorithms are profiled to improve performance:

* Optimised applications can be dramatically slowed by bad I/O design (e.g. shared log-files, small I/O operations)
* New layers in the I/O stack like **burst buffers** improve efficiency of I/O in legacy applications

Long-term I/O needs to move away from POSIX (with consistent concurrent reads and writes):

* **Object base storage** requires data movement to be part of the application design
* "Lazy" data organization with directory trees suddenly disappears
* Performance optimizations of I/O patterns is required for each individual storage infrastructure

Eventually a distinction between read-only, write-only and read-write data is required.

* Most of the data should be read-only and immutable (after being written once)
* Write-only data (e.g. checkpoints) data can be signed off when the writer has finished
* Data constantly in change (read-write) should live in a database
