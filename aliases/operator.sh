#
# Copyright 2013 Victor Penso
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

export IPMI_USER=${1:-"ADMIN"}

# connect to a service module using IPMI serial over lan
function ipmi-sol() { 
  : ${1:?"Missing service module address!"}
  ipmitool -I lanplus -H $1 -U $IPMI_USER -a sol activate 
}

function ipmi-nodes() {
  local command="--stat"
  case "$1" in
  on) command="--on" ;;
  off) command="--off" ;;
  reset) command="--reset" ;;
  help) 
    echo "ipmi-nodes on|off|reset|status" 
    return
    ;;
  esac
  : ${NODES:?"Specifiy host list in NODES"}
  ipmipower -h "$(echo $NODES)" -u $IPMI_USER -P $command
}

# run Clustershell using the NODES environment variable
alias rush='clush -l root -w $NODES'
