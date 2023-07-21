import subprocess
import os
import shutil
from pathlib import Path

def find_pkgbuild_dirs(root_path):
    root_path = Path(root_path)
    pkg_dirs = []

    # Recursively traverse the root path and look for "PKGBUILD" files in each directory.
    for path in root_path.rglob("PKGBUILD"):
        if path.is_file():
            pkg_dirs.append(path.parent)

    return pkg_dirs

def build_and_sign_packages(pkg_dirs):
    for pkg_dir in pkg_dirs:
        print(f"\nBuilding and signing packages in {pkg_dir}...")
        
        subprocess.run(["updpkgsums"], cwd=pkg_dir, check=True)
        subprocess.run(["makepkg", "-f", "-scr", "--sign"], cwd=pkg_dir, check=True)
        

        # Move the generated files to the script's directory
        for file in pkg_dir.glob("*.pkg.tar.zst"):
            shutil.move(file, Path(__file__).parent)
        for file in pkg_dir.glob("*.pkg.tar.zst.sig"):
            shutil.move(file, Path(__file__).parent)

def main():
    # Set the root path from which to start the search
    root_path = "./packages/FIXED/impacket"

    pkg_dirs = find_pkgbuild_dirs(root_path)

    if not pkg_dirs:
        print("No directories containing PKGBUILD found.")
        return

    print("Directories containing PKGBUILD found:")
    for dir in pkg_dirs:
        print(dir)

    build_and_sign_packages(pkg_dirs)

if __name__ == "__main__":
    main()
