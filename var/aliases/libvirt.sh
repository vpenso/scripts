#
# Copyright 2013-2015 Victor Penso
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


function vm() {
  local command=$1
  shift
  case "$command" in
  "create"|"c") 
    virsh create "$@" 
    ;;
  "define"|"d") 
    virsh define "$@" 
    ;;
  "list"|"l") 
    virsh list --all 
    ;;
  "remove"|"r") 
    virsh shutdown "$1" 
    virsh undefine "$1"
    ;;
  "shutdown"|"h") 
    virsh shutdown "$1" 
    ;;
  "start"|"s") 
    virsh start "$1" 
    ;;
  "undefine"|"u") 
    virsh undefine "$@"
    ;;
  *) 
    echo "Usage: vm (c)reate|(d)efine|s(h)utdown|(l)ist|(r)emove|(s)tart|(u)ndefine [args]" 
    ;;
  esac
}
