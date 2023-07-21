#!/bin/bash

# Function to find directories containing PKGBUILD files
find_pkgbuild_dirs() {
    root_path=$1
    pkg_dirs=()

    # Recursively traverse the root path and look for "PKGBUILD" files in each directory.
    while IFS= read -r -d '' path; do
        pkg_dirs+=("$path")
    done < <(find "$root_path" -type f -name "PKGBUILD" -print0)

    echo "${pkg_dirs[@]}"
}

# Function to build and sign packages
build_and_sign_packages() {
    src_dir=$(pwd)
    for pkg_dir in "${pkg_dirs[@]}"; do
        echo -e "\nBuilding and signing packages in $pkg_dir..."
        current_dir=$(dirname $pkg_dir)
        cd $current_dir

        updpkgsums
        pkgname=$(grep "^pkgname=" PKGBUILD | awk -F"=" '{print $2}')
        pkgrel=$(grep "^pkgrel=" PKGBUILD | awk -F"=" '{split($2,a," ");gsub(/"/, "", a[1]);print a[1]}')
        arch=$(grep "^arch=" PKGBUILD | awk -F"'" '{print $2}')
        pkgver=$(grep "^pkgver=" PKGBUILD | awk -F"=" '{print $2}')
        pkgfile=$pkgname-$pkgver-$pkgrel-$arch.pkg.tar.zst

        makepkg -f -scr
        passphrase="$PASSPHRASE"
        if [ -n "$passphrase" ]; then
            echo $passphrase | sudo -E -u builder gpg --detach-sign --use-agent --pinentry-mode loopback --passphrase --passphrase-fd 0 --output $pkgfile.sig $pkgfile
        else
            echo "Error: 'PASSPHRASE' environment variable not set."
            break
        fi

        cd $src_dir
    done
}

# Set the root path from which to start the search
root_path="./"

# Find directories containing PKGBUILD files
pkg_dirs=($(find_pkgbuild_dirs "$root_path"))

if [ "${#pkg_dirs[@]}" -eq 0 ]; then
    echo "No directories containing PKGBUILD found."
    exit 1
fi

echo
echo "Finding fastest Arch mirrors. Don't be scared of any WARNING message here. I'm just finding the fastest mirrors for you..."
echo
sudo reflector --age 6 --latest 21 --fastest 21 --threads 21 --sort rate --protocol https --save /etc/pacman.d/mirrorlist 2> /dev/null
sudo pacman -Syyu

echo "Directories containing PKGBUILD found:"
printf '%s\n' "${pkg_dirs[@]}"

# Build and sign packages
build_and_sign_packages