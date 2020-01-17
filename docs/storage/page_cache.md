## Page Cache

Page cache **accelerates accesses to files** on non volatile storage for two
reasons:

1. Overcome the slow performance of permanent storage (like hard disk)
2. Load data only once into RAM and share it between programs

The page cache uses **free areas of memory as cache storage**:

* All **regular file I/O happens through the page cache**
* Data not in sync with the storage marked as **dirty pages**

Dirty pages are periodically synchronized as soon as resources are available

* After programs write data to the page cache it is as marked dirty
* The program dose not block waiting for the write to be finished
* Until the sync is completed power failure may lead to data loss
* Write of critical data requires explicit blocking until data is written
* Programs reading data typically block until the is available
* The kernel uses **read ahead** to preload data in anticipation
  of sequential reads

The kernel frees the memory used for page cache if it is required for other
applications:

```bash
free -hw                  # shows page cache in dedicated column
```

Force the Linux kernel to **synchronize dirty pages** with the storage:

```bash
sync                      # force write of dirty pages
# track the progress in writing dirty pages to storage:
watch -d grep -e Dirty: -e Writeback: /proc/meminfo
```
