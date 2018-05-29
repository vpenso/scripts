## MiniKube

Install [Minikube][minikube] within a KVM based virtual machine instance.

[minikube]: https://kubernetes.io/docs/getting-started-guides/minikube/

Enable KVM **nested virtualization**:

```bash
>>> cat /etc/modprobe.d/kvm-nested.conf
options kvm-intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1
# reload the kernel module (stop all VMs beforehand)
>>> modprobe -r kvm_intel && modprobe -a kvm_intel
# check for the support
>>> cat /sys/module/kvm_intel/parameters/nested
Y
```

This example uses a virtual machine instance setup with **vm-tools**:

<https://github.com/vpenso/vm-tools>

```bash
# new CentOS 7 default instance 
vm shadow centos7 lxdev01
vm shutdown lxdev01
# overwrite the VM instance configuration, enable nested VMs 
vm config lxdev01 --overwrite --passthrough --vcpus 2 --memory 8
vm redefine lxdev01
vm start lxdev01
vm login lxdev01 --root
```

Install Minikube:

```bash
# install kubctl from the RPM package repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
# install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.27.0/minikube-linux-amd64 
chmod +x minikube 
sudo mv minikube /usr/local/bin/
# install libvirt tools
yum install -y libvirt-daemon-kvm libvirt-daemon-config-network libvirt-client qemu-kvm
# start the default network
virsh net-autostart default
# install the KVM2 docker driver 
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 
chmod +x docker-machine-driver-kvm2
sudo mv docker-machine-driver-kvm2 /usr/local/bin/
```

Brief demo of Minikube usage:

```bash
# start VM instance
minikube start --vm-driver kvm2
# VM instance state
minikube status
minikube service list
# do stuff...
kubectl run hello-minikube --image=k8s.gcr.io/echoserver:1.4 --port=8080
kubectl expose deployment hello-minikube --type=NodePort
kubectl get pod
curl $(minikube service hello-minikube --url)
kubectl delete services hello-minikube
kubectl delete deployment hello-minikube
# stop VM instance
minikube stop
# remove VM instance
minikube delete
```

