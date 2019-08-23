## Page Cache

Page cache **accelerates accesses to files** on non volatile storage for two
reasons:

1. Overcome the slow performance of permanent storage (like hard disk)
2. Load data only once into RAM and share it between programs

The page cache uses **free areas of memory as cache storage**:

* All **regular file I/O happens through the page cache**
* Data not in sync with the storage marked **dirty pages**

Dirty pages are periodically synchronized as soon as resources are available

* Programs write bytes the page cache, which then is as marked dirty page
* The program dose not block waiting for IO
* Until the sync is completed power failure may lead to data loss
* Write of critical data requires explicit blocking until data is written
* Programs reading block until the data is available
* The kernel uses **read ahead** to preload data in anticipation of sequential
  reads

```bash
free -hw                  # shows page cache in dedicated column
```

Force the Linux kernel to synchronize dirty pages with the storage:

```
sync                      # force write of dirty pages
# track the progress in writing dirty pages to storage:
watch -d grep -e Dirty: -e Writeback: /proc/meminfo
```
