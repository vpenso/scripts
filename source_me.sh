#
# Copyright 2012-2019 Victor Penso
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

function _debug() {
        if [ "$_DEBUG" = "true" ]; then
                echo 1>&2 "Debug: $@"
        fi
}

## Repository Environment Variable ##

# default location
__source=$HOME/projects/scripts/source_me.sh
# try to determine the source_me.sh file location
shell=$(ps -p $$ | tail -n1 | tr -s ' ' | sed -e 's/^[ \t]*//' | cut -d' ' -f4)
# in Bash shells
if [ "$shell" = "bash" ]
then
	__source=$BASH_SOURCE[0]
# in Zsh shells
elif [ "$shell" = "zsh" ]
then
	__source="${(%):-%x}"
else
	echo \[W\] Using default: \"$__source\" 
fi

__dir="$( dirname $__source )"
while [ -h $__source ]
do
  __source="$( readlink "$__source" )"
  [[ $__source != /* ]] && __source="$__dir/$__source"
  __dir="$( cd -P "$( dirname "$__source" )" && pwd )"
done
__dir="$( cd -P "$( dirname "$__source" )" && pwd )"

export SCRIPTS=$__dir

unset __dir
unset __source

## Load Scripts, Configuration and Aliases ##

export PATH=$PATH:$SCRIPTS/bin
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')

for file in `\ls $SCRIPTS/var/aliases/*.sh`
do
	_debug source $file
  	source $file
done
