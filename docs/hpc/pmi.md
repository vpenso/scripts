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

* Defines standard APIs (not the implementation) [pxstd]
* Open Source reference implementation of the standard [ompix]
* Fully supports both of the existing PMI-1 and PMI-2 APIs
* Auto-negotiation messaging protocol from v2.1.x onwards

## References

[brgcb] PMIx: Bridging the Container Boundary (2019)  
<https://pmix.org/wp-content/uploads/2019/04/PMIxSUG2019.pdf>  
<https://www.youtube.com/watch?v=9u4xmXpQU_U>

[ebsmc] Evaluation and Benchmarking of Singularity MPI Containers (2019/20)  
<https://www.canopie-hpc.org/wp-content/uploads/2019/12/prace_azab.pdf>

[ormch] On-node Resource Manager for Containerized HPC Workloads (2019/12)  
<https://www.canopie-hpc.org/wp-content/uploads/2019/12/PMIx-Canopie-HPC-2019.pdf>

[opmix] OpenPMIx Implementation of the PMIx Standard  
<https://github.com/openpmix/openpmix/releases>

[pstd2] PMIx Standard  
<https://pmix.org/pmix-standard/>

[spmid] A Scalable PMIx Database  
<https://eurompi2018.bsc.es/sites/default/files/uploaded/dstore_empi2018.pdf>
