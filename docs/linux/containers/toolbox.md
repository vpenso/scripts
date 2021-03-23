# Toolbox


Fully mutable container environment for everyday software development and
debugging. Built on top of Podman and OCI standard container technologies.

From the Fedora documentation [tbxfd]:

_Each toolbox container is an environment that you can enter from the command
line. Inside each one, you will find:_

* _Your existing username and permissions_
* _Access to your home directory and several other locations_
* _Access to both system and session D-Bus, system journal and Kerberos_
* _Common command lines tools, including a package manager_


## Images

_Toolbox customizes newly created containers in a certain way. This requires
certain tools and paths to be present and have certain characteristics inside
the OCI image. ... Toolbox enables sudo(8) access inside containers_ [tbxsc]

Fedora images for toolbox:

<https://github.com/containers/toolbox/tree/master/images/fedora>

Create a toolbox container:

* Download an OCI container image from a registry (if available)
* By default an image matching the version of the host
* If the host system does not have a matching image, a Fedora image is used instead

```bash
toolbox create # using the defaults
toolbox enter
```

Use a specific version of Fedora:

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

### References

[tbxsc] Toolbox Source Code Repository, GitHub  
<https://github.com/containers/toolbox>

[tbxfd] Toolbox, Fedora Documentation  
<https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/>
