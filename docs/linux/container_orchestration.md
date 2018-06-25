# Container Orchestration

_Automated arrangement, coordination, and management of software containers_

Containerized workloads:  portable, insulated, independent dependencies

* **COE** - Container Orchestration Engines, aka. Container as a Service (CaaS)
* **WMS** - HPC Workload Management Systems with container support

Open-Source for container orchestration: 

Name                                | Family | Cf.
------------------------------------|--------|--------------------------------
PBS (Portable Batch System)         | WMS    | http://pbspro.org
HT (High Throughput) Condor         | WMS    | http://research.cs.wisc.edu/htcondor
Slurm                               | WMS    | https://slurm.schedmd.com
Mesos¹ (with Marathon)              | COE    | http://mesos.apache.org
Kubernetes                          | COE    | https://kubernetes.io
Docker Swarm                        | COE    | https://docs.docker.com/engine/swarm

¹Mesos is a common resource management system hosting multiple distributed computing (workload management) frameworks (2-level scheduling).

WMS oriented workload management semantics do not naturally integrate with COE:

* (Help users to) move HPC workloads into containers and migrate to the CaaS resource management (cloud-style)
* Operate HPC workload management over CaaS resource management as underlying substrate (comparable to HPC on IaaS) (cf. [Slurm on Google Cloud Platform](https://github.com/SchedMD/slurm/tree/slurm-17.11/contribs/gcp))

## User Workloads

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

## Workload Execution

**Match/execute** user workloads **efficently** on available computing resources:

Classification of workload schedulers:

Type             | Description
-----------------|--------------------------------
monolithic       | Single central scheduling for all tasks (i.e. all HPC WMS, Kubernetes, Swarm)
two-level        | Separate resources allocation from task placement (i.e. Mesos)
shared state     | Shared state (protocol) for multiple (application specific) schedulers (no examples)

Many possible **resource metrics** and **tunable settings** for the scheduling algorithm

* Resource - amount, type, duration, cost/power, topology...
* Account - user, group, project, tags, limits...
* Policies - job size/age, priority, fair share, reservation,...

Methods to **optimize mapping** of requested resources to the available resources:

Method            | Description
------------------|-------------------------------------------------
time sharing      | Allocate multiple workloads from one or more user on a single node
backfilling       | Schedule pending workloads out of order to maximize utilization
job chunking      | Run similar workloads of multiple users simultaneously
bin packing       | Group workloads of multiple user to optimize utilization
gang scheduling   | Allow users to submit multiple process within a single workload
job dependencies  | Allow user to define workflows for execution (direct acyclic graphs (DAGs))


### Workload Management

Responsibilities/components of a workload management system:

Component            | Description
---------------------|----------------------------------------
scheduling           | Allocate resources and assign a workload from the queue
lifecycle management | Receive and queue workloads, prioritize/sort candidate workloads
resource management  | Collect resource capabilities and state information for the scheduler
execution/monitoring | Launch the workload, track its state and collect performance metrics 


**Resource management** typically involves following capabilities:

Capability               | Description
-------------------------|-------------------------------------------
heterogeneous resources  | The scheduler can accommodate different hardware configurations
allocation policy        | Prioritization of jobs according to specific resource requirements (i.e. run-time)
consumable resources     | Enforced static (CPUs, RAM) and dynamic (load, bandwidth) resource constrains
network-aware scheduling | Consideration of network topology by the scheduler for job allocation

**Workload placement** is usually highly configurable:

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


