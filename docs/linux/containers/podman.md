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

## Rootless

```bash
dnf install slirp4netns fuse3-devel
# check the storage driver
grep "driver.*=.*overlay" /etc/containers/storage.conf
# check the number of available user namespaces
cat /proc/sys/user/max_user_namespaces
# configure the ID space for a user
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $user
grep $user /etc/sub{uid,gid}
```

## References

[podman] Podman - Library and tool for running OCI-based containers in Pods  
https://github.com/containers/libpod

[rootless] Basic Setup and Use of Podman in a Rootless environment  
https://github.com/containers/libpod/blob/master/docs/tutorials/rootless_tutorial.md
