#!/bin/bash
### Emacs.sh - GNU Emacs Mac port startup script.

## Copyright (C) 2012-2015  YAMAMOTO Mitsuharu

## This file is part of GNU Emacs Mac port.

## GNU Emacs Mac port is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## GNU Emacs Mac port is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

### Code:

export EMACS_REINVOKED_FROM_SHELL=1
set "${0%.sh}" "$@"

case $(sw_vers -productVersion) in
    10.[0-7]|10.[0-7].*)
	# "$HOME/.MacOSX/environment.plist" is ignored on OS X 10.8.
	if [ -f "$HOME/.MacOSX/environment.plist" ]; then
	    # Invocation via "Login Items" or "Resume" resets PATH.
	    case ${SHLVL} in
		1)
		    p=$(defaults read "$HOME/.MacOSX/environment" PATH 2>/dev/null) && PATH=$p
		    ;;
	    esac
	    exec "$@"
	fi
	;;
esac

case ${SHLVL} in
    1) ;;
    *) exec "$@" ;;
esac

case ${SHELL##*/} in
    bash)	exec -l "${SHELL}" --login -c 'exec "$@"' - "$@" ;;
    ksh|sh|zsh)	exec -l "${SHELL}" -c 'exec "$@"' - "$@" ;;
    csh|tcsh)	exec -l "${SHELL}" -c 'exec $argv:q' "$@" ;;
    es|rc)	exec -l "${SHELL}" -l -c 'exec $*' "$@" ;;
esac

# Fall back on bash.
exec -l /bin/bash --login -c 'exec "$@"' - "$@"
