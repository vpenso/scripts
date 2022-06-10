
```sh
# Fedora & Enterprice Linux
sudo dnf install -y buildah
```

```sh
# download a container image
>>> buildah from centos
# list available images
>>> buildah images     
REPOSITORY              TAG      IMAGE ID       CREATED         SIZE
quay.io/centos/centos   latest   300e315adb2f   18 months ago   217 MB
# list available containers
>>> buildah containers
CONTAINER ID  BUILDER  IMAGE ID     IMAGE NAME                       CONTAINER NAME
c820e2e17aa7     *     300e315adb2f quay.io/centos/centos:latest     centos-working-container
# clean up everything
>>> buildah rm --all  
c820e2e17aa7f0cec3d2f0af033c216d7bd583d3fa0aec0b5db2d12d5d26031b
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
