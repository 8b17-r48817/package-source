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

        passphrase = os.getenv("PASSPHRASE")
        if passphrase:
            # Use 'expect' to automate passphrase entry for makepkg
            expect_script = f'''
                spawn makepkg -sr --sign
                expect "Enter passphrase for key" {{ send "{passphrase}\\n" }}
                expect eof
            '''

            try:
                subprocess.run(["expect", "-c", expect_script], cwd=pkg_dir, check=True)
            except subprocess.CalledProcessError as e:
                print(f"Error building packages in {pkg_dir}: {e}")
                continue
        else:
            print("Error: 'PASSPHRASE' environment variable not set.")
            break

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
