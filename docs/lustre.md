

The **lfs** utility provides options to monitor and configure Lustre:

```bash
findmnt -t lustre --df                 # list Lustre file-systems with mount point
lfs help                               # list available options
lfs help <option>                      # show option specific information
lfs osts                               # list vailable OSTs
lfs osts | tail -n1 | cut -d: -f1      # number of OSTs
lfs df -h [<path>]                     # storage space per OST
lfs quota -h -u $USER [<path>]         # storage quota for a user
lfs find -print -type f <path>         # find files in a directory
```

### Striping

Split a file into small sections (stripes) and distribute these to multiple OSTs.

* Advantages:
  - The **file size** can be bigger then the storage capacity of a single OST.
  - Enables to utilize the **I/O bandwidth** of multiple OSTs while accessing a single file.
* Disadvantages:
  - Placing stripes of a file across multiple OSTs requires a **management overhead**. (Hence small files should not be striped)
  - A higher number of OSTs holding stripes of a file increases the **risk to losing access** as soon as a single OST is unreachable. 

```bash
lfs getstripe <file|dir>                    # show striping information
lfs setstripe -c <stripe_count> <file|dir>  # configure the stripe count  
lfs setstripe -i 0x<idx> <file|dir>         # target a specific OST
```

* File inherit the striping configuration of their parent directory.
* Application I/O performance is influenced by choosing the right file size and stripe count.
* **Stipe Count** (default 1)
  - By default a single file is stored to a single OST.
  - A count of `-1` stripes across all available OSTs (eventually used for very big files).
* **Stripe Size** (default 1MB)
  - Maximum size of the individual stripes.
  - Lustre sends data in 1MB chunks → stripe size are recommended to range between 1MB up to 4MB
