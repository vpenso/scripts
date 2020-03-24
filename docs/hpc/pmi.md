# PMI - Process Management Interface

> Component of the HPC software stack that is responsible for interaction
between a Resource Manager (RM) and a parallel application... informational
exchange between RM and application is organized in the form of a key-value
database (KVDb) that has Put, Get operations and API-specific synchronization
primitives. [spmid]

A **Process Manager** (PM) serves several purposes for parallel applications:

* Handle start/stop of processes
* Aggregation of I/O channels `std{in|out|err}`
* Environment and signal propagation
* Central **coordination point of parallel processes**

PMI provides a common **abstraction to HPC process managers**

* _Decouple process management from the underlying process manager_
* Standardized APIs (compatibility across all PMI/PMIx versions)

**Used by MPI libraries** to interact with any compliant system (like SLURM):

* Requests the PM to start processes on the nodes of a parallel machine
* Propagate startup data with PMI out-of-band communication
* Processes use out-of-band communication to setup MPI communication

## PMIx

Process Management Interface - Exascale (PMIx):

* Defines standard APIs (not the implementation) [pstd2]
* Open Source reference implementation of the standard [ompix]
* Fully supports both of the existing PMI-1 and PMI-2 APIs

## References

[brgcb] PMIx: Bridging the Container Boundary  
<https://pmix.org/wp-content/uploads/2019/04/PMIxSUG2019.pdf>

[opmix] OpenPMIx Implementation of the PMIx Standard  
<https://github.com/openpmix/openpmix/releases>

[pstd2] PMIx Standard 2.2  
<https://pmix.org/wp-content/uploads/2019/02/pmix-standard-2.2.pdf>

[spmid] A Scalable PMIx Database  
<https://eurompi2018.bsc.es/sites/default/files/uploaded/dstore_empi2018.pdf>
