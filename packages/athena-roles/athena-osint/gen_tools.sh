#!/bin/sh

to_exclude=("facebrok" "trape" "vpnpivot")

sed -i '/depends=/d' PKGBUILD
sed -i '/^$/d' PKGBUILD #Delete all empty lines

printf '\n' >> PKGBUILD #Avoid that the new "depends" string is placed on an existing row
printf 'depends=( ' >> PKGBUILD
printf "'%s' " $(pacman -Sgq blackarch-recon blackarch-social | awk '!seen[$0]++' | sed -e "$(sed 's:.*:s/^&$//ig:' <<<$(printf "%s\n" "${to_exclude[@]}"))") >> PKGBUILD
printf "'de4dot' 'netz' 'sleuthkit' 'sn0int' 'sniffglue' " >> PKGBUILD
printf ')\n' >> PKGBUILD
