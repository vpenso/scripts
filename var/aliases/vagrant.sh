# if VirtualBox is not installed...
if command -v virtualbox >/dev/null
then
        export VAGRANT_DEFAULT_PROVIDER=virtualbox
else
        # ...but vagrant is installed...
        command -v vagrant >/dev/null && {
                # ...assume that Libvirt is used as provider
                export VAGRANT_DEFAULT_PROVIDER=libvirt
                export LIBVIRT_DEFAULT_URI=qemu:///system
        }
fi
