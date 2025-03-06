#!/usr/bin/env zsh
#!          ░▒▓         
#!        ░▒▒░▓▓         
#!      ░▒▒▒░░░▓▓           ___________
#!    ░░▒▒▒░░░░░▓▓        //___________/
#!   ░░▒▒▒░░░░░▓▓     _   _ _    _ _____
#!   ░░▒▒░░░░░▓▓▓▓▓▓ | | | | |  | |  __/
#!    ░▒▒░░░░▓▓   ▓▓ | |_| | |_/ /| |___
#!     ░▒▒░░▓▓   ▓▓   \__  |____/ |____/    ▀█ █▀ █░█
#!       ░▒▓▓   ▓▓  //____/                █▄ ▄█ █▀█

# HyDE's ZSH env configuration
# This file is sourced by ZSH on startup
# And ensures that we have an obstruction free ~/.zshrc file
# This also ensures that the proper HyDE $ENVs are loaded

# Function to handle initialization errors
function handle_init_error {
    if [[ $? -ne 0 ]]; then
        echo "Error during initialization. Please check your configuration."
    fi
}

# Function to remove the lock file on exit
function cleanup {
    rm -f /tmp/.hyde_slow_load_warning.lock
}

function no_such_file_or_directory_handler {
    local red='\e[1;31m' reset='\e[0m'
    printf "${red}zsh: no such file or directory: %s${reset}\n" "$1"
    return 127
}


# cleaning up home folder
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CONFIG_DIR="${XDG_CONFIG_DIR:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}"
XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-$HOME/Templates}"
XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-$HOME/Public}"
XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-$HOME/Documents}"
XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-$HOME/Music}"
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
LESSHISTFILE=${LESSHISTFILE:-/tmp/less-hist}
PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"

# wget
WGETRC="${XDG_CONFIG_HOME}/wgetrc"
SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc

export XDG_CONFIG_HOME XDG_CONFIG_DIR XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR \
XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR WGETRC SCREENRC 



if [ -t 1 ];then
    # Detect AUR wrapper and cache it for faster subsequent loads
    aur_cache_file="/tmp/.aurhelper.zshrc"
    if [[ -f $aur_cache_file ]]; then
        aurhelper=$(<"$aur_cache_file")
    else
        if pacman -Qi yay &>/dev/null; then
            aurhelper="yay"
        elif pacman -Qi paru &>/dev/null; then
            aurhelper="paru"
        fi
        echo "$aurhelper" > "$aur_cache_file"
    fi


    # Optionally load user configuration // usefull for customizing the shell without modifying the main file
    [[ -f ~/.hyde.zshrc ]] && source ~/.hyde.zshrc


    # Helpful aliases
    if [[ -x "$(which eza)" ]]; then
        alias ls='eza' \
            l='eza -lh --icons=auto' \
            ll='eza -lha --icons=auto --sort=name --group-directories-first' \
            ld='eza -lhD --icons=auto' \
            lt='eza --icons=auto --tree'
    fi

    alias c='clear' \
        un='$aurhelper -Rns' \
        up='$aurhelper -Syu' \
        pl='$aurhelper -Qs' \
        pa='$aurhelper -Ss' \
        pc='$aurhelper -Sc' \
        po='$aurhelper -Qtdq | $aurhelper -Rns -' \
        vc='code' \
        ..='cd ..' \
        ...='cd ../..' \
        .3='cd ../../..' \
        .4='cd ../../../..' \
        .5='cd ../../../../..' \
        mkdir='mkdir -p' # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
fi
