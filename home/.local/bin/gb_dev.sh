(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

[ $SOURCED -eq 0 ] && echo Please source $0 && exit 1

printf "**************************************************\n"
printf "* Welcome to the Dev KIT Pro environment.        *\n"
printf "* Useful for Nintendo Wii, Gamecube, DS, GBA,    *\n"
printf "* Gamepark GP32 and Nintendo Switch development. *\n"
printf "**************************************************\n"

env DEVKITPRO=/opt/devkitpro DEVKITARM=/opt/devkitpro/devkitARM \
    DEVKITPPC=/opt/devkitpro/devkitPPC \
    $(ls -o /proc/$$/exe | awk '{ print $NF }')

printf "Development is finished.\n"
