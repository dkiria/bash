#! /bin/bash
#.install_command_gui.sh

action=$(yad --width 500 --height 100 --entry --title "command app" \
    --image=gnome-start \
    --button="Switch User:2" \
    --button="gtk-ok:0" --button="gtk-close:1" \
    --text "Choose action:" \
    --entry-text \
    "ls" "dns_start" "dns_stop"  "scp"  "Reboot" "Suspend" "Logout" "ps" "df" "date" "ssh" "cfg_parser" "ifconfig ")
ret=$?

[[ $ret -eq 1 ]] && exit 0

if [[ $ret -eq 2 ]]; then
    gdmflexiserver --startnew &
    exit 0
fi
case $action in
    dns_start*) cmd="sudo /etc/init.d/dnsmasq start" ;;
    dns_stop*) cmd="sudo /etc/init.d/dnsmasq stop" ;;
    ifconfig*) cmd="ifconfig" ;;
    scp*) cmd="./scp2.py" ;;
    ls*) cmd="ls" ;;
    ps*) cmd="ps" ;;
    df*) cmd="df" ;;
    date*) cmd="date" ;;
    ssh*) cmd="./ssh6a.py" ;;
    cfg_parser*) cmd="./tes.sh" ;;
    Reboot*) cmd="sudo /sbin/reboot" ;;
    Suspend*) cmd="sudo /bin/sh -c 'echo disk > /sys/power/state'" ;;
    Logout*) 
    case $(wmctrl -m | grep Name) in
        *Openbox) cmd="openbox --exit" ;;
        *FVWM) cmd="FvwmCommand Quit" ;;
            *Metacity) cmd="gnome-save-session --kill" ;; 
        *) exit 1 ;;
    esac
    ;;
    *) exit 1 ;;    
esac

eval exec $cmd
