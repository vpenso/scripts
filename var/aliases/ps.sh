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

# List of all processes including their hierarchy
alias psa=ps -AfH

# Comprehensive inspection of the process tree
alias pstree=pstree -lpu

# Print a sorted list of all processes by CPU utilization
alias pscpu="ps -A -o ruser,pcpu,time,state,args --sort pcpu"

# Continuously updated list of all running processes
alias runs="watch -n1 ps r -AL -o stat,pid,user,psr,pcpu,pmem,args"

