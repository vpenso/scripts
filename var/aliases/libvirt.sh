#
# Copyright 2013-2016 Victor Penso
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

export LIBVIRT_DEFAULT_URI=qemu:///system

export VM_IMAGE_PATH=~/vms/images
export VM_INSTANCE_PATH=~/vms/instances

alias vi=virsh-instance
alias vc=virsh-config

function vm() {
  local command=$1
  case "$command" in
  "create"|"c") 
    shift
    virsh create "$@" 
    ;;
  "define"|"d") 
    shift
    virsh define "$@" 
    ;;
  "kill"|"k")
    shift
    virsh undefine "$1"
    virsh destroy "$1" 
    ;;
  "list"|"l") 
    virsh list --all 
    ;;
  "remove"|"r") 
    shift
    virsh undefine "$1"
    virsh shutdown "$1" 
    ;;
  "shutdown"|"h") 
    shift
    virsh shutdown "$1" 
    ;;
  "start"|"s") 
    shift
    virsh start "$1" 
    ;;
  "undefine"|"u") 
    shift
    virsh undefine "$@"
    ;;
  *) 
    echo "Usage: vm (c)reate|(d)efine|s(h)utdown|(k)ill|(l)ist|(r)emove|(s)tart|(u)ndefine [args]" 
    ;;
  esac
}

