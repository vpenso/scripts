#
# Copyright 2012-2025 Victor Penso
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

#export _DEBUG=true
function _debug() {
        if [ "$_DEBUG" = "true" ]; then
                echo 1>&2 "Debug: $@"
        fi
}

# default location
export SCRIPTS=$HOME/projects/scripts
_debug SCRIPTS=$SCRIPTS
export PATH=$SCRIPTS/bin:$PATH

# add executables in home-directory if present 
test -d ~/bin \
    && export PATH=~/bin:$PATH
test -d ~/.local/bin \
    && export PATH=~/.local/bin:$PATH

for file in \
	$SCRIPTS/var/aliases/nix.sh \
	$SCRIPTS/var/aliases/password.sh \
	$SCRIPTS/var/aliases/common.sh \
	$SCRIPTS/var/aliases/cd.sh \
	$SCRIPTS/var/aliases/ls.sh \
	$SCRIPTS/var/aliases/browser.sh \
	$SCRIPTS/var/aliases/git.sh \
	$SCRIPTS/var/aliases/bookmarks.sh \
	$SCRIPTS/var/aliases/fzf.sh \
	$SCRIPTS/var/aliases/quarto.sh \
	$SCRIPTS/var/aliases/btop.sh \
	$SCRIPTS/var/aliases/bat.sh

do
	_debug source $file
  	source $file
done
