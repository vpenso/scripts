# if VirtualBox is not installed...
if ! command -v virtualbox >/dev/null
then
        # ...but vagrant is installed...
        command -v vagrant >/dev/null && {
                # ...assume that Libvirt is used as provider
                export VAGRANT_DEFAULT_PROVIDER=libvirt
        }
fi
