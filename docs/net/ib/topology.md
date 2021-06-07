# Topology

topology (roadmap of the network)

* critical aspect of any interconnection network
* defines how the channels and routers are connected
* sets performance bounds (network diameter, bisection bandwidth)
* determines the cost of the network

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

**Fat-Tree** topologies provide (non-)blocking fabrics

- Consistent hop count, resulting in predictable latency.
- They do not scale linearly with cluster size (max. 7 layers/tiers)
- The switches at the top of the pyramid shape are called **Spines**/Core
- The switches at the bottom of the Pyramid are called **Leafs**/Lines/Edges
- **External Connections** connect nodes to edge switches.
- **Internal Connections** connect core with edge switches.
- **Constant Bisectional Bandwidth** (CBB)
  - Non blocking (1:1 ratio)
  - Equal number of external and internal connections (balanced)
- **Blocking** (x:1), external connections is higher than internal connections, over subscription

## Torrus

**Torus** (Cube/Mesh) 3D topologies, CBB ratio 1:6

- Every switch node is connected to six neighbors
- Add orthogonal dimensions of interconnect as they grow
- Simple wiring using shorter cables, and expandable without re-cabling
- Can be optimized for localized and/or global communication within the cluster
- Requires routing engine to handle loops

## Dragonfly 

* network groups: multiple nodes are connected within a fat tree
* direct one-to-one connection between each network group
  - avoids the need for external top level switches
  - reduce number of long links and network diameter (total cost of network)
* requires adaptive routing to enable efficient operation


