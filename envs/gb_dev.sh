#!/bin/sh

(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

[ $SOURCED -eq 0 ] && echo Please source $0 && exit 1

export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM
export DEVKITPPC=/opt/devkitpro/devkitPPC
