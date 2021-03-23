# Toolbox

Unprivileged fully mutable container environment for everyday software
development and debugging. 

* Front-end built on top of Podman and OCI standard container technologies.
* Keeps the host system small and decoupled from development environments

From the Fedora documentation [tbxfd]:

_Each toolbox container is an environment that you can enter from the command
line. Inside each one, you will find:_

* _Your existing username and permissions_
* _Access to your home directory and several other locations_
* _Access to both system and session D-Bus, system journal and Kerberos_
* _Common command lines tools, including a package manager_

_Toolbox customizes newly created containers in a certain way. This requires
certain tools and paths to be present and have certain characteristics inside
the OCI image. ... Toolbox enables sudo(8) access inside containers_ [tbxsc]

Fedora images for toolbox [fedim] are available from the Fedora container
registry [fedcr].

Create a toolbox container:

* Downloads an OCI container image from a registry (if available)
* By default an image matching the version of the host
* If the host system does not have a matching image Fedora is used instead
* OCI image called `<ID>-toolbox:<VERSION-ID>` (cf. `/usr/lib/os-release`)

```bash
toolbox create # using the defaults
toolbox enter
# quit the current container with `exit`
```

Use a specific version of Fedora:

```bash
toolbox --image fedora-toolbox:34 create
toolbox enter --release 34
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

List of common sub-commands:

```bash
toolbox list -c           # list containers
toolbox rm -f $name       # remove a container (even if it is running) 
toolbox rmi -f $image     # remove a container image (even if it is running)
toolbox rmi -a            # remove all images
```

### References

[tbxsc] Toolbox Source Code Repository, GitHub  
<https://github.com/containers/toolbox>  
<https://src.fedoraproject.org/rpms/toolbox>

[tbxfd] Toolbox, Fedora Documentation  
<https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/>

[fedim] Fedora ToolBox Images, GitHub  
<https://github.com/containers/toolbox/tree/master/images/fedora>

[fedcr] Fedora Container Registry  
<https://registry.fedoraproject.org/>

[tblxg] `tblx`, GitLab  
<https://gitlab.com/uppercat/tlbx>
