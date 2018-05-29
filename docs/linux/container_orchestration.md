# Container Orchestration

_Automated arrangement, coordination, and management of software containers_

Containerized workloads:  portable, insulated, independent dependencies

HPC **WMS** (Workload Management Systems) with container support and **CaaS** (Container as a Service):

Name                                | Family
------------------------------------|-------------------
[PBS][pbs] (Portable Batch System)  | WMS
Univa GridEngine (Navops)           | WMS
HT (High Throughput) Condor         | WMS
[Slurm][slurm]                      | WMS
[Mesos][mesos]¹ & [Marathon][mthon] | CaaS
[Kubernetes][kubs]                  | CaaS
Docker [Swarm][swarm]               | CaaS

¹Mesos is a common resource management system hosting multiple distributed computing (workload management) frameworks (2-level scheduling).

[pbs]: http://pbspro.org/
[slurm]: https://slurm.schedmd.com/
[mesos]: http://mesos.apache.org/documentation
[mthon]: https://mesosphere.github.io/marathon/
[kubs]: https://kubernetes.io/docs/
[swarm]: https://docs.docker.com/engine/swarm/

HPC oriented workload management semantics do not naturally integrate with CaaS resource management:

* (Help users to) move HPC workloads into containers and migrate to the CaaS resource management (cloud-style)
* Operate HPC workload management over CaaS resource management as underlying substrate (comparable to HPC on IaaS) (cf. [Slurm on Google Cloud Platform](https://github.com/SchedMD/slurm/tree/slurm-17.11/contribs/gcp))

## Workloads

Users Submit a wide variety of **computational applications** (jobs, tasks) for processing

* Different parallel **execution paradigms** (levels of parallelism)
* Different **execution requirements** (i.e. run-time, required hardware (CPUs, RAM,etc.))

Workload      | Description
--------------|------------------------------------
service       | Service (daemon) process (long running, persistent execution)
batch         | Single (independent) processes (sequential execution)
array         | Pleasantly parallel processes (asynchronously executed)
parallel      | Synchronously parallel processes (simultaneous execution)
periodical    | Processes executed in a defined interval
analytics     | Combination of the above categories

## Workload Managers (Schedulers)

**Match and execute** compute workloads from multiple users **efficently** on the available computational resources

- **Lifecycle management** - Receive and queue workloads, prioritize/sort candidate workloads (queue management policies)
- **Resource management** - Collect resource capabilities and state information for the scheduler
- **Scheduling** - Allocate resources and assign a workload from the queue
- **Execution & monitoring** - Launch the workload, track its state and collect performance metrics 

### Resource management

* Heterogeneous resources - The scheduler can accommodate different hardware configurations
* Allocation policy - Prioritization of jobs according to specific resource requirements (i.e. run-time)
* Consumable resources - Enforced static (CPUs, RAM) and dynamic (load,bandwidth) resource constrains
* Network-aware scheduling - Consideration of network topology by the scheduler for job allocation

### Scheduling methods

* Timesharing - Allocate multiple workloads from one or more user on a single node
* Backfilling - Schedule pending workloads out of order to maximize utilization
* Job Chunking - Run similar workloads of multiple users simultaneously
* Bin Packing - Group workloads of multiple user to optimize utilization
* Gang scheduling - Allow users to submit multiple process within a single workload
* Job dependencies - Allow user to define workflows for execution (direct acyclic graphs (DAGs))

### Workload placement

* Prioritization - Consider user/group priorities, fair-share policies during scheduling
* Replacement/reordering - Dynamically manged job order in the queue to react to state changes (resource, jobs, etc)
* Reservation - Request resources in the future (guarantees resource availability)
* Power-aware scheduling - Drain, shutdown unused nodes to minimize power consumption
* Prolog/epilog support - Allow scripts to be executed before/after a job
* Data staging - Support for copying files to local storage before job execution
* Checkpointing - Allow applications to save execution state in intervals (fault-tolerance)
* Job migration - Move jobs during execution to mitigate failure states (rebalancing of long-running or service-oriented jobs)
* Job restarting - Automatic restart of aborted of failed jobs
* Job preemption - Suspend low-priority jobs to free resources of required


