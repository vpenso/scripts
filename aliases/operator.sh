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

# connect to a service module using IPMI serial over lan
function sol() { 
  local host=$1
  local user=$2
  ipmitool -I lanplus -H $host -U $user -a sol activate 
}

# run Clustershell using the NODES environment variable
alias rush='clush -l root -w $NODES'
