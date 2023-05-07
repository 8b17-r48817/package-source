#!/bin/sh

#NEED ONLY TO EDIT  sourcefiles VARIABLE

sourcefiles="icons"

pkgname=$(grep "^pkgname=" PKGBUILD | awk -F"=" '{print $2}')
pkgver=$(grep "^pkgver=" PKGBUILD | awk -F"=" '{print $2}')
pkgrel=$(grep "^pkgrel=" PKGBUILD | awk -F"=" '{split($2,a," ");gsub(/"/, "", a[1]);print a[1]}')
arch=$(grep "^arch=" PKGBUILD | awk -F"'" '{print $2}')

pkgfile=$pkgname-$pkgver-$pkgrel-$arch.pkg.tar.zst

echo $pkgfile

#sed -i -e '/^sha256/d' -e '/^sha512/d' PKGBUILD

tar -zcvf $pkgname.tar.gz $sourcefiles 

#makepkg -g >> PKGBUILD
makepkg -f -scr --sign

rm -rf src pkg $pkgname.tar.gz Gruvbox-GTK-Theme Fuchsia-Pop.tar.gz rtl88-Themes

rm -rf ../../$pkgfile ../../$pkgfile.sig

mv $pkgfile $pkgfile.sig ../../
