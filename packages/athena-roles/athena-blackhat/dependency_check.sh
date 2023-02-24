#!/bin/sh

if [ ! -f PKGBUILD ]; then
    echo "PKGBUILD not found in the current directory."
    exit 1
fi

read -p "Type the name of dependency you want to check: " target

deps=$(grep "^depends=" PKGBUILD | awk -F"=" '{print $2}' | sed -e "s/[()']//g" -e "s/ /\n/g" | sed '/^$/d')

echo "Checking for nested dependencies"
while read -r dep
do
    list=$(pacman -Si $dep | grep "Depends On" | sed -e "s/Depends On      : //g" -e "s/  /\n/g" | awk '!seen[$0]++' | awk -F"=" '{print $1}' | awk -F".so" '{print $1}') #Extract sub-dependencies for each package dep
    while read -r subdep
    do
        if [ $target == "$subdep" ]; then
            echo "The PKGBUILD dependency "$dep" contains the provided dependency $target."
        fi
    done <<< $list
    
    if [ $target == "$dep" ]; then
        echo "The typed dependency "$dep" is directly inside the PKGBUILD ad dependency."
    fi
done <<< $deps
