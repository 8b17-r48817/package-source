#!/bin/sh

to_exclude=("argus-clients" "xplico" "gerix-wifi-cracker" "pmacct" "sagan" "fastnetmon" "vpnpivot" "ncpfs")

sed -i '/depends=/d' PKGBUILD
sed -i '/^$/d' PKGBUILD #Delete all empty lines

printf '\n' >> PKGBUILD #Avoid that the new "depends" string is placed on an existing row
printf 'depends=( ' >> PKGBUILD
printf "'%s' " $(pacman -Sgq blackarch-ids blackarch-networking blackarch-proxy blackarch-radio blackarch-sniffer blackarch-spoof blackarch-tunnel blackarch-wireless | awk '!seen[$0]++' | sed -e "$(sed 's:.*:s/^&$//ig:' <<<$(printf "%s\n" "${to_exclude[@]}"))") >> PKGBUILD
printf ')\n' >> PKGBUILD
