# AppStream

AppStream (Application Stream) allows to install **multiple versions of a user
space component**.

* Each AppStream component has a given life cycle
* Packaged as RPM modules or individual RPM packages

**Modules are collections of packages** representing a logical unit.

* Module streams represent versions of the AppStream components.
* Each of the streams receives updates independently.
* **Active streams** give the system access to the RPM packages within the
  particular module stream
* Only one stream of a particular module can be active at a given point in time
* Module may have a **default stream** which usually provides the latest or
  recommended version of the component. `[d]` flag marks a default stream.
* Not all modules are compatible with all other modules.
* Modular dependencies are an additional layer on top of regular RPM
  dependencies.
* System will always retain the module and stream choices, unless explicitly
  instructed to change them.

Select a module with a module specification:

    NAME:STREAM:VERSION:CONTEXT:ARCH/PROFILE

```bash
# using ruby as example module
yum module list                   # list all available modules
yum module list ruby*             # list specific modules by name
yum module info ruby              # details, package list
yum module install ruby:2.6
yum install @ruby:2.6             # install a specific modules in a specific version
# or
yum module enable ruby:2.6        # make a module default, and active
yum install ruby
```

Switch to a later stream:

```bash
# i.e. ruby 2.5 is installed
yum distro-sync
yum module reset ruby
yum module enable ruby:2.6
# update to the ruby 2.6 stream
yum disto-sync

