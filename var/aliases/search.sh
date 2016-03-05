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

alias f="find . -type f -exec grep -l \"$1\" {} \;;"

# colorize matched patterns when using `grep` by default
grep_command='--color=auto'
# exclude version control repositories from search
for PATTERN in .cvs .git .hg .svn; do
   grep_command="$grep_command --exclude-dir=$PATTERN"
done
export GREP_COLOR='1;38;5;52;48;5;166'
export GREP_COLORS='ms=00;34:mc=00;34:sl=:cx=:fn=35:ln=37:bn=32:se=36'
alias grep="grep $grep_command"


export ACK_PAGER_COLOR="less -x4SRFX"

alias ack='ack-grep -a'
