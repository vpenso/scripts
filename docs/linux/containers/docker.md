# Docker

> Docker is a platform for developers and sysadmins to build, share, and run applications with containers...Fundamentally, a container is nothing but a running process, with some added encapsulation features applied to it in order to keep it isolated from the host and from other containers.

## Install

Installation [on Debian](https://docs.docker.com/install/linux/docker-ce/debian/):

```bash
# install dependencies for deployment
sudo apt update
sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common
# add the official GPG key for the Docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
# setup the stable repository for x86_64/amd64 ISA
sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"
# install the latest version of Docker Community Edition
sudo apt-get update
sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io
```

Sudo configuration for a user to run `docker` command without password as root:

```bash
echo "$USER ALL = (root) NOPASSWD:SETENV: $(which docker) *" | \
        sudo tee --append /etc/sudoers.d/$USER
# prepend sudo before the docker command
alias docker='sudo docker'
```

## Usage

The Docker client `docker` is the primary way that many Docker users interact 
with Docker. Docker objects:

* **Images** are read-only template with instructions for creating a Docker container
  - Create custom images by describing it in a `Dockerfile`
  - Images may be derived from another image (eventually downloaded from a image
  registry)
  - Each instruction in a Dockerfile creates a layer in the image
  - Rebuild the image after changes to the Dockerfile
* **Containers** a runnable instance of an image

Simple example using a container from a registry:

```bash
# start a dummy container
docker run hello-world
# list local container images
docker image ls -a
# state of containers
docker container ls -a
# remove all exited containers at once
docker container prune -f
# remove the image
docker image rm hello-world
```

Simple example building a container from a `Dockerfile`:

```bash
# write a simple container definition file
cat > Dockerfile <<EOF
FROM alpine
RUN /bin/echo "Hello World" > /root/message
CMD [ "/bin/cat", "/root/message" ]
EOF
# create a container image from the definition
docker build -t hello-world .
# execute the container
docker run hello-world
```

Pull an Debian container from registry and start running interactively and 
attached to the terminal to execute Bash:

```bash
docker run -i -t debian /bin/bash
```


### References

[dec] Docker Community Engine  
https://docs.docker.com/install/

[dno] Docker Networking Overview  
https://docs.docker.com/network/

[dfr] Dockerfile Reference  
https://docs.docker.com/engine/reference/builder/


