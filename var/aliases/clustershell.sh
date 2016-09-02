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

# quick export NODES environment variable
function NODES() {
  if [ $# -lt 1 ]
  then
    : ${NODES:?}
    echo $NODES
  else
    export NODES=$@
  fi
}

alias NODES='noglob NODES'

# stdin is exported as environment variable
function exp() { read n; export $1=$n }

# pipe into the NODES environment variable
alias -g NE='| exp NODES'

alias -g NF='| nodeset -f'
alias -g NC='| nodeset -c'

# run Clustershell using the NODES environment variable
alias rush='clush -l root -w $NODES'

alias nodeset-accessible='noglob nodeset-accessible'

function nodeset-fping() {
  fping $(nodeset -e $NODES) 2>$-
}


