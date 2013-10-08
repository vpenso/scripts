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

function @google-translate() { 
  local lang=${1:-"en/de"}
  shift 2>-
  $BROWSER "http://translate.google.com/#$lang/$(uri-encode $@)" 
}

alias @g.t="@google-translate de/en"

function @google() { 
  local lang=${1:-"en"}
  shift 2>-
  $BROWSER "http://www.google.com/search?h1=$lang#q=$(uri-encode $@)"
}

alias @g="@google en"
alias @g.de="@google de"
