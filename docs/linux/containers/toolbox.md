# Toolbox

Built on top of Podman, and OCI standard container technologies.

Provides a fully mutable container used for development and debugging of applications.

## Images

>>>
Toolbox customizes newly created containers in a certain way. This requires
certain tools and paths to be present and have certain characteristics inside
the OCI image.
>>>

Fedora images for toolbox:

<https://github.com/containers/toolbox/tree/master/images/fedora>

```bash
toolbox --image fedora-toolbox:34 create
toolbox enter --release 34
toolbox list
```

Build a Debian/Ubuntu toolbox image with:

<https://piware.de/gitweb/?p=bin.git;a=blob;f=build-debian-toolbox>

```bash
wget -O ~/bin/build-debian-toolbox \
      'https://piware.de/gitweb/?p=bin.git;a=blob_plain;f=build-debian-toolbox'
chmod +x ~/bin/build-debian-toolbox
# i.e. Ubuntu
build-debian-toolbox 20.10 ubuntu
toolbox enter 20.10
```

Toolbox Source Code Repository, GitHub  
<https://github.com/containers/toolbox>
