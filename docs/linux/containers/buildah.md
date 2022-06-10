
```sh
# Fedora & Enterprice Linux
sudo dnf install -y buildah
```

Download a container image from a public repository and start a shell:

```sh
# ...for example latest RockyLinux
>>> buildah from rockylinux           
...
rockylinux-working-container     # <- name of the container
# ...automatically started
>>> buildah containers     
CONTAINER ID  BUILDER  IMAGE ID     IMAGE NAME                       CONTAINER NAME
c5162c15716e     *     c830f8e8f82b docker.io/library/rockylinux:... rockylinux-working-container
# shell into the container
>>> buildah run rockylinux-working-container bash
[root@c5162c15716e /]# exit
exit
# remove the container
>>> buildah rm rockylinux-working-container      
c5162c15716e2f679a23ca59347ca380bbee238b8759e02ebd8927ef2aae417b
```

```
# new container with a defind name
buildah from --name rocky rockylinux
# execute a command to install some packages
buildah run rocky -- dnf install -y epel-release dnf-plugins-core
buildah run rocky -- dnf config-manager --set-enabled powertools
buildah run rocky -- dnf install -y slurm-slurmctld
# run a deamon in foreground
buildah run rocky -- slurmctld -Dvvvv
```

Simple example building a HTTP server container:

```sh
buildah from fedora
# install a web-server to the container
buildah run fedora-working-container -- dnf install -y httpd
# move a file into the container
echo "Hello World" > /tmp/index.html
buildah copy fedora-working-container /tmp/index.html /var/www/html
buildah config --entrypoint "/usr/sbin/httpd -D FOREGROUND" fedora-working-container
buildah commit fedora-working-container fedora-httpd
podman run fedora-httpd
```

[^1] Buildah Project Page  
<https://buildah.io>
