#
# Copyright 2012 Victor Penso
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

# (re)set git mail address environment variable
function git-mail() {
  local mail=${1:-"$USER@localhost"}
  export GIT_AUTHOR_EMAIL=$mail
  export GIT_COMMITTER_EMAIL=$mail
  echo "GIT_AUTHOR_EMAIL=$GIT_AUTHOR_EMAIL"
  echo "GIT_COMMITTER_EMAIL=$GIT_COMMITTER_EMAIL"
}
