# Topology

topology (roadmap of the network)

* critical aspect of any interconnection network
* defines how the channels and routers are connected
* sets performance bounds (network diameter, bisection bandwidth)
* determines the cost of the network
* keys to topology evaluation
  - network throughput - for application traffic patterns
  - network diameter - min/avg/max latency between hosts
  - scalability - cost of adding new end-nodes
  - cost per host - number of network routers/ports per end-node

**routing**

* determines the path packets travel from source to destination
* efficient routing algorithm required to reach performance bounds
* load-balance the topology on adversarial traffic patterns

**flow control**

* policy to allocates the different resources in the network (buffers, channels)
* prevent deadlock and livelock in the network

**diameter** defines the maximum distance between two node (hop count)

* lower network diameter
  - better performance
  - smaller cost (less cables & routers)
  - less power consumption

**radix** (or degree) of the router defines the number of ports per router

* low-radix, (torus 3/5D, hypercube, long hop)
  - long network diameter
  - lower path diversity
  - pool load balancing
* high-radix (fat tree, dragonfly)
  - router complexity increases quadratically
  - negatively impacts the router cycle time

nodal degree: how  many  links  connect  to  each node

## Fat-Tree

* pros
  - simple routing
  - maximal network throughput
  - fault-tolerant (path diversity)
  - credit loop deadlock free routing
* cons
  - large diameter...
  - ...more expensive

most common topology

- consistent hop count, resulting in predictable latency.
- does not scale linearly with cluster size (max. 7 layers/tiers)
- switches at the top of the pyramid shape are called **Spines**/Core
- switches at the bottom of the pyramid are called **Leafs**/Lines/Edges
- **external connections** connect nodes to edge switches.
- **internal connections** connect core with edge switches.
- constant bisectional bandwidth (CBB)
  - non blocking (1:1 ratio)
  - equal number of external and internal connections (balanced)
- **blocking** (x:1), external connections is higher than internal connections, over subscription

## Torrus

**Torus** (Cube/Mesh) 3D topologies, CBB ratio 1:6

- Every switch node is connected to six neighbors
- Add orthogonal dimensions of interconnect as they grow
- Simple wiring using shorter cables, and expandable without re-cabling
- Can be optimized for localized and/or global communication within the cluster
- Requires routing engine to handle loops

## Dragonfly

* pros
  - reduce number of long links and network diameter...
  - reduced total cost of network
  - more scalable (compared to fat-tree)
* cons
  - more complex routing

Hierarchical topology dividing hosts to groups

* all-to-all connection between each network group
  - avoids the need for external top level switches
  - each group has at least on direct link to other groups
* requires adaptive routing to enable efficient operation
  - Fully Progressive Adaptive Routing (FPAR)

Flavors diverge on **group topology**

* 1D flattened butterfly, completely connected (default recommendation)
* 2D flattened butterfly
* Dragonfly+ (benefits of Dragonfly and Fat Tree)

Locality, **group size**

* Lager group size, larger amount of group-internal traffic
* Dragonfly+ and Fat Tree groups have full bi-sectional bandwidth 

