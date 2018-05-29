# Resource Management Systems

The operating system of a data center is the **job scheduler**.

**Match and execute** compute jobs from multiple users **efficently** on the available computational resources

- Job **lifecycle management** - Receive and queue jobs, prioritize/sort candidate jobs (queue management policies)
- **Resource management** - Collect resource capabilities and state information for the scheduler
- Job **scheduling** - Allocate resources and assign a job from the queue
- Job **execution & monitoring** - Launch the job, track the state and collect performance metrics 

## Jobs

**Jobs** - Users Submit a wide variety of computational applications for processing

* Different parallel **execution paradigms** (levels of parallelism)
* Different **execution requirements** (i.e. run-time, required hardware (CPUs, RAM,etc.))

Job           | Description
--------------|------------------------------------
service       | Service (daemon) process (long running, persistent execution)
batch         | Single (independent) processes (sequential execution)
array         | Pleasantly parallel processes (asynchronously executed)
parallel      | Synchronously parallel processes (simultaneous execution)
periodical    | Processes executed in a defined interval
analytics     | Combination of the above categories

## Schedulers

RMS supporting containers:

Name                                                  | Family
------------------------------------------------------|-------------------
[PBS][pbs] (Portable Batch System)                    | HPC
GridEngine                                            | HPC
HT (High Throughput) Condor                           | HPC
[Slurm][slurm]                                        | HPC
[Mesos][mesos] & [Marathon][mthon]                    | CaaS
[Kubernetes][kubs]                                    | CaaS
Docker [Swarm][swarm]                                 | CaaS

[pbs]: http://pbspro.org/
[slurm]: https://slurm.schedmd.com/
[mesos]: http://mesos.apache.org/documentation
[mthon]: https://mesosphere.github.io/marathon/
[kubs]: https://kubernetes.io/docs/
[swarm]: https://docs.docker.com/engine/swarm/

Recent trend to package job execution environment into **containers** (portable, insulated, independent).

Challenges of migrating HPC workloads to containers:

* Execute containerized workloads with an existing HPC workload manager
* Migrate HPC workloads to CaaS (i.e. Kubernetes, Mesos/Marathon)
* Host HPC and CaaS concurrently on the same resources

### Resource management

* Heterogeneous resources - The scheduler can accommodate different hardware configurations
* Allocation policy - Prioritization of jobs according to specific resource requirements (i.e. run-time)
* Consumable resources - Enforced static (CPUs, RAM) and dynamic (load,bandwidth) resource constrains
* Network-aware scheduling - Consideration of network topology by the scheduler for job allocation

### Scheduling methods

* Timesharing - Allocate multiple jobs from one or more user on a single node
* Backfilling - Schedule pending jobs out of order to maximize utilization
* Job Chunking - Run similar jobs of multiple users simultaneously
* Bin Packing - Group jobs of multiple user to optimize utilization
* Gang scheduling - Allow users to submit multiple process within a single job
* Job dependencies - Allow user to define workflows for job execution (direct acyclic graphs (DAGs))

### Job placement

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


