#!/bin/sh

detect_virt=$(systemd-detect-virt)

if ([ ! -z "$DISPLAY" ] && [ "$DISPLAY" != ":0" ]) || ([ "$detect_virt" != "docker" ] && [ "$detect_virt" != "podman" ] && [ "$detect_virt" != "wsl" ]); then

    FLAGFILE="$HOME/.flag-work-once"
    #FLAGNET="$HOME/.flag-net-once"

    if [ -f "$FLAGFILE" ]; then

        ############################################################

        xdg-mime default org.gnome.Nautilus.desktop inode/directory
         
        ############################################################

        sh ~/.vim_runtime/install_awesome_parameterized.sh ~/.vim_runtime $USER

        rm -rf "${HOME}/.config/gtk-4.0"
        mkdir -p "${HOME}/.config/gtk-4.0"

        package=athena-akame-theme
        if pacman -Qq $package > /dev/null ; then
            theme_name="Nightfox-Dusk-B"
            gnome_shell="Nightfox-Dusk-B"

            color_scheme="prefer-dark"
            icon_theme="Material-Black-Cherry-Suru"
            cursor_theme="Bibata-Modern-DarkRed"
            background_theme="/usr/share/backgrounds/default/akame.jpg"
            picture_options="stretched"

            topbarcolorscheme="finale"
            topbarmaterialscheme="finale"
            topbariconscheme="dark"
            musicbarscheme="#F98D89"
        fi

        package=athena-blue-eyes-theme
        if pacman -Qq $package > /dev/null ; then
            theme_name="Tokyonight-Dark-B"
            gnome_shell="Tokyonight-Dark-B"

            color_scheme="prefer-dark"
            icon_theme="Tokyonight-Dark"
            cursor_theme="oreo_blue_cursors"
            background_theme="/usr/share/backgrounds/default/blue-eyes.jpg"
            picture_options="stretched"

            topbarcolorscheme="ripples"
            topbarmaterialscheme="default"
            topbariconscheme="dark"
            musicbarscheme="#6FE7FB"
        fi

        package=athena-graphite-theme
        if pacman -Qq $package > /dev/null ; then
            theme_name="Graphite-Dark"
            gnome_shell="Graphite-Dark"

            color_scheme="prefer-dark"
            icon_theme="Tela-circle-black-dark"
            cursor_theme="Bibata-Modern-Ice"
            background_theme="/usr/share/backgrounds/default/arch-ascii.png"
            picture_options="stretched"

            topbarcolorscheme="nowthatitstrue"
            topbarmaterialscheme="default"
            topbariconscheme="dark"
            musicbarscheme="#197FAF"
        fi

        package=athena-gruvbox-theme
        if pacman -Qq $package > /dev/null ; then
            theme_name="Gruvbox-Dark-BL"
            gnome_shell="Gruvbox-Dark-BL"

            color_scheme="prefer-dark"
            icon_theme="Material-Black-Mango-Suru"
            cursor_theme="Fuchsia-Pop"
            background_theme="/usr/share/backgrounds/default/cyborg_gruv.png"
            picture_options="stretched"

            topbarcolorscheme="valhalla"
            topbarmaterialscheme="virtuality_yellow"
            topbariconscheme="gruv"
            musicbarscheme="#EFD69C"
        fi

        package=athena-sweet-dark-theme
        if pacman -Qq $package > /dev/null ; then
            theme_name="Sweet-Dark-v40"
            gnome_shell="Sweet-Dark-v40"

            color_scheme="prefer-dark"
            icon_theme="Sweet-Purple"
            cursor_theme="oreo_spark_purple_cursors"
            background_theme="/usr/share/backgrounds/default/neon_circle.jpg"
            picture_options="stretched"

            topbarcolorscheme="something"
            topbarmaterialscheme="amaryllis"
            topbariconscheme="dark"
            musicbarscheme="#FE3DAF"
        fi

        gsettings set org.gnome.desktop.interface gtk-theme $theme_name
        gsettings set org.gnome.desktop.wm.preferences theme $theme_name
        gsettings set org.gnome.shell.extensions.user-theme name $gnome_shell

        gsettings set org.gnome.desktop.interface color-scheme $color_scheme
        gsettings set org.gnome.desktop.interface icon-theme $icon_theme
        gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme
        gsettings set org.gnome.desktop.background picture-uri-dark file://$background_theme
        gsettings set org.gnome.desktop.background picture-uri file://$background_theme
        gsettings set org.gnome.desktop.background picture-options $picture_options

        ln -sf "/usr/share/themes/$theme_name/assets" "${HOME}/.config/assets"
        ln -sf "/usr/share/themes/$theme_name/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
        ln -sf "/usr/share/themes/$theme_name/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"

        # Top-right resource statistics color
        cp -rf $HOME/.config/eww/css/savedcolors/_colorscheme_$topbarcolorscheme.scss $HOME/.config/eww/css/_colorscheme.scss
        cp -rf $HOME/.config/eww/css/savedcolors/_iconcolor_$topbarcolorscheme.txt $HOME/.config/eww/css/_iconcolor.txt

        # Top bar color
        cp -rf $HOME/.config/eww/css/savedcolors/_material_$topbarmaterialscheme.scss $HOME/.config/eww/css/_material.scss

        # Top bar icon colors
        cp -rf $HOME/.config/eww/images/svg/$topbariconscheme/* $HOME/.config/eww/images/svg/

        # Hyprland border colors
        cp -rf $HOME/.config/hypr/savedcolors/colors_$topbarcolorscheme.conf $HOME/.config/hypr/colors.conf

        # Hyprland wallpaper
        cp -rf $background_theme $HOME/.config/eww/images/wallpaper/wallpaper
        pkill swaybg
        swaybg -i $HOME/.config/eww/images/wallpaper/wallpaper &

        # Music bar color
        sed -ir "s/\"color4\":\"#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\"/\"color4\":\"$musicbarscheme\"/g" $HOME/.config/eww/scripts/music
     
        ###### TERMINAL CHECK ######

        binterm="foot" #fallback
        if pacman -Qq alacritty &> /dev/null; then
          binterm="alacritty"
        elif pacman -Qq cool-retro-term &> /dev/null; then
          binterm="cool-retro-term"
        elif pacman -Qq kitty &> /dev/null; then
          binterm="kitty"
        elif pacman -Qq konsole &> /dev/null; then
          binterm="konsole"
        elif pacman -Qq terminator &> /dev/null; then
          binterm="terminator"
        elif pacman -Qq terminology &> /dev/null; then
          binterm="terminology"
        elif pacman -Qq xfce4-terminal &> /dev/null; then
          binterm="xfce4-terminal"
        elif pacman -Qq xterm &> /dev/null; then
          binterm="xterm"
        elif pacman -Qq foot &> /dev/null; then # Fallback Wayland
          binterm="foot"
        elif pacman -Qq gnome-terminal &> /dev/null; then # Fallback generic
          binterm="gnome-terminal"
        fi
        sed -i "s/bind = SUPER, Return, exec, foot/bind = SUPER, Return, exec, $binterm/g" "$HOME/.config/hypr/keybinds.conf"

        ###########################

        ###### BROWSER CHECK ######
         
        binbrowser="firefox-esr" #fallback
        if pacman -Qq brave-bin &> /dev/null; then
          binbrowser="brave"
        elif pacman -Qq mullvad-browser &> /dev/null; then
          binbrowser="mullvad-browser"
        elif pacman -Qq firefox-esr &> /dev/null; then # Fallback at the end of if statement
          binbrowser="firefox-esr"
        fi
        sed -i "s/bind = SUPER, W, exec, brave/bind = SUPER, W, exec, $binbrowser/g" "$HOME/.config/hypr/keybinds.conf"

        ###########################

        rm -rf "$FLAGFILE"

        systemctl --user enable --now psd
        ln -s "$HOME/.mozilla/firefox-esr" "$HOME/.mozilla/firefox"    
    fi

    #if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    #    if [ -f "$FLAGNET" ]; then
    #    # Commented for keeping nist-feed disable. The user decides if enable it.
    #    #	/usr/local/bin/nist-feed -n -l
    #    	rm -rf "$FLAGNET"
    #    fi
    #    /usr/local/bin/htb-update
    #fi

    #If tun0 is down (i.e., after a reboot), the shell prompt must be updated with the running interfaces
    if ! nmcli c show --active | grep -q tun ; then

        /usr/local/bin/prompt-reset

    fi
fi
