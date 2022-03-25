# Podman

> Podman provides a docker compatible command line experience enabling users to 
> find, run, build, and share containers

> Podman consists of just a single command to run on the command line. There 
> are no daemons in the background doing stuff, and this means that Podman can
> be integrated into system services through systemd.

Simple example using a container from a registry:

```bash
# start a dummy container
podman run hello-world
# list local container images
podman image ls -a
# state of containers
podman ps -a
# remove the dummy container
podman rm --latest
```

Simple example building a container from a `Dockerfile`:

```bash
name=httpd
# write a simple container definition file
cat > Dockerfile <<EOF
FROM centos:latest
RUN yum -y install httpd
CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]
EXPOSE 80
EOF
# build the container
podman build -t $name .
# check the image
podman image ls $name
# start the container
podman run -dit -p 80:80 $name
```

## Container Images

Search for images on remote registries with `search` sub-command:

```shell
# search with filter
>>> podman search --filter=is-official rockylinux
INDEX       NAME                          DESCRIPTION                         STARS       OFFICIAL    AUTOMATED
docker.io   docker.io/library/rockylinux  The official build of Rocky Linux.  23          [OK]        
# list tags of a specific image
>>> podman search --list-tags quay.io/rockylinux/rockylinux
NAME                           TAG
quay.io/rockylinux/rockylinux  8.4-rc1
quay.io/rockylinux/rockylinux  8.4
quay.io/rockylinux/rockylinux  8.5
quay.io/rockylinux/rockylinux  latest
quay.io/rockylinux/rockylinux  8
```

Download `pull` and container image:

```shell
>>> podman pull quay.io/rockylinux/rockylinux:8.5          
Trying to pull quay.io/rockylinux/rockylinux:8.5...
Getting image source signatures
Copying blob 72a2451028f1 done  
Copying config a1e37a3cce done  
Writing manifest to image destination
Storing signatures
a1e37a3cce8f954b7a802d41974c7cd8dbe8c529c7d9a253fba1d6cd679230f1
# list all images, present on your machine
>>> podman images                                
REPOSITORY                                 TAG         IMAGE ID      CREATED       SIZE
quay.io/almalinux/almalinux                latest      6bfdc3e60b10  2 weeks ago   205 MB
quay.io/almalinux/almalinux                8.5         6bfdc3e60b10  2 weeks ago   205 MB
registry.fedoraproject.org/fedora-toolbox  35          09cc3fe0e1d0  2 weeks ago   497 MB
quay.io/rockylinux/rockylinux              8.5         a1e37a3cce8f  4 months ago  211 MB
```

## Use Containers

Sub-command      | Description
-----------------|---------------------------
`run`            | Run a process in a new container.
`exec`           | Execute a command in a running container.

Start a new container with `run` and attach to an interactive shell:

```shell
>>> podman run -ti --name rl8 quay.io/rockylinux/rockylinux:8.5 /bin/bash
[root@819d84365f2c /]# exit
exit
# start the container and attach
>>> podman start --attach rl8
[root@4d5af1e0a044 /]# exit
exit
# remove the container
>>> podman rm rl8            
4d5af1e0a044acc7bb530776eb4319c77aa6a05921018f9f72a5be55d29a7653
```


## References

[podman] Podman
<https://podman.io/>

