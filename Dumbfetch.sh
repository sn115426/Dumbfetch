#!/bin/sh

exec 2> /dev/null

os=$(uname -no)
read -r _ _ version _ < /proc/version
host=$(cat /sys/devices/virtual/dmi/id/product_family)
packages=$(xbps-query -l | wc -l)
mem=$(free -m | awk 'FNR==2 {print $3"M/"$2"M"}')
kernel=$(echo "$version" | cut -d "-" -f1)
shell=$(basename "$SHELL")

wm=$(xprop -id "$(xprop -root -notype | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}')" -notype -f _NET_WM_NAME 8t | grep "WM_NAME" | cut -f2 -d \")


thing() {
    if [ -n "$2" ]; then
        printf "%6s -> \t%s\n" "$1" "$2"
    else
        printf ""
    fi
}
getpkgs() {
    pkgs=""

    if [ $(command -v kiss) ]
    then
        pkgs="$(kiss l | wc -l) (kiss)"
    fi

    if [ $(command -v pacman) ]
    then
        pkgs="$pkgs $(pacman -Q | wc -l) (pacman)"
    fi

    if [ $(command -v emerge) ]
    then
        pkgs="$pkgs $(ls -d /var/db/pkg/*/* | wc -l) (portage)"
    fi

    if [ $(command -v xbps-query) ]
    then
        pkgs="$pkgs $(xbps-query -l | wc -l) (xbps)"
    fi

    if [ $(command -v apk) ]
    then
        pkgs="$pkgs $(apk info | wc -l) (apk)"
    fi

}


    thing "os" "$os"
    thing "host" "$host"
    thing "kernel" "$kernel"
    thing "shell" "$shell"
    thing "wm" "$wm"
    thing "pkgs" "$packages"
    thing "mem" "$mem"
    

