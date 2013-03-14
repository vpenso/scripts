Read the [OpenNebula documentation][one] on the developers site.

Users can send a security token derived from any SSH private key to 
the administrator:

    » oneuser key --key /path/to/key/id_rsa > /tmp/oneuser_$USER.key
    Enter PEM pass phrase:

The administrator create a new user account:

    » oneuser create $USER --ssh --read-file /tmp/oneuser_$USER.key
    » onegroup list
    [...SNIP...]
    » oneuser chgrp -v $USER $GROUP
    » oneuser list 
    [...SNIP...]

Furthermore the new user should be added to an already defined group. 
Once the user account is enabled a connection from the client side can be
established with:

    » export ONE_XMLRPC=http://$FRONTEND:2633/RPC2
    » oneuser login $USER --ssh --key /path/to/key/id_rsa
    [...SNIP...]
    export ONE_AUTH=/home/$USER/.one/one_ssh

After login users can survey the infrastructure:

    » onehost list
    [...SNIP...]
    » onevm list
    [...SNIP...]
    » oneimage list
    [...SNIP...]
    » onevnet list
    [...SNIP...]

The following creates a virtual machine instance which will boot from
the network (PXE):

    » cat vm_instance.one 
    NAME = lxdev01.devops.test
    CPU = 1
    MEMORY = 1024
    DISK = [ IMAGE_ID = 2, target = "vda" ]
    NIC = [ NETWORK_ID = 1, IP = "10.1.1.50" ]
    OS = [ BOOT = "network", ARCH = x86_64 ]
    GRAPHICS = [ TYPE = "vnc", LISTEN  = "0.0.0.0" , port="5901"]
    » onevm create vm_instance.one

As soon as the node enters the `runn` state it is possible to connect
via VNC.

    » onevm list
    [...SNIP...]
    » onevm show $VM_ID
    [...SNIP...]
    » onevm delete $VM_ID

[one]: http://opennebula.org
