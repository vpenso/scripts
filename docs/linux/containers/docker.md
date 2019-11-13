# Docker

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
```

## Usage

Simple example using a container from a registry

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


### References

[dec] Docker Engine - Community  
https://docs.docker.com/install/
