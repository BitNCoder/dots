#!/bin/bash

# NOTES
# -------------
# waybar can be toggled via `killall -SIGUSR1 waybar`
# waybar can be reloaded via `killall -SIGUSR2 waybar`
#
# killing waybar with SIGUSR2 forces waybar to be shown again
#
# need to track some things such as if/which workspace is a zen workspace, waybar status, etc
#
# start by checking if waybar is alive at startup, and if not, then don't start
#
# if waybar is running at start, then continue and run.
# also garuntee the state of hide/show by SIGUSR2
# if waybar is ever dead, then always assume it is shown

ZEN_ID=$(hyprctl -j workspaces | jaq -r '.[] | select(.name == "zen") | .id')
ACTIVE_ID=$(hyprctl -j activeworkspace | jaq -r '.id')

HIDE_FILE=/tmp/waybar_hidden

hide() {
    # echo hide
    if [ -z $(pgrep '^waybar$') ] && [ -e $HIDE_FILE ]; then
	rm $HIDE_FILE
    elif [ ! -z $(pgrep '^waybar$') ] && [ ! -e $HIDE_FILE ]; then
	killall -SIGUSR1 waybar
	touch $HIDE_FILE
    fi
}

show() {
    # echo show
    if [ -z $(pgrep '^waybar$') ] && [ -e $HIDE_FILE ]; then
	rm $HIDE_FILE
    elif [ ! -z $(pgrep '^waybar$') ] && [ -e $HIDE_FILE ]; then
	killall -SIGUSR1 waybar
	rm $HIDE_FILE
    fi
}

handle() {
	#    case $1 in
	# workspacev2* | renameworkspace*) echo $1;;
	#    esac
    
    PARAM=${1#*'>>'}
    case $1 in
	workspacev2*)
	    ACTIVE_ID=${PARAM%%','*}
	    # if the workspace changed, check name and conditionally hide bar
	    if [ "${PARAM##*','}" = "zen" ]; then
		hide
	    else
		show
	    fi
	    ;;
	renameworkspace*)
	    TGT_ID=${PARAM%%','*}
	    TGT_NAME=${PARAM##*','}
	    if [ ! -z $ZEN_ID ] && [ $TGT_ID = $ZEN_ID ] && [ ! $TGT_NAME = "zen" ]; then
		ZEN_ID=""
		if [ $TGT_ID = $ACTIVE_ID ]; then
		    show
		fi
	    elif [ $TGT_NAME = "zen" ]; then
		ZEN_ID=$TGT_ID
		if [ $TGT_ID = $ACTIVE_ID ]; then
		    hide
		fi
	    fi
    esac
}

run() {
	#    if [ -z $(pgrep "^waybar$") ]; then
	# echo "Waybar not running... exiting" >> /var/tmp/autohide.log
	# exit
	#    fi
    
    while [ -z $(pgrep "^waybar$") ]; do
	sleep 1
    done

    # waybar is running, make sure it is currently shown
    if [ -e $HIDE_FILE ]; then
	rm $HIDE_FILE
    fi
    
    # Check if active workspace is zen workspace, and, if so, hide
    if [ $(hyprctl -j activeworkspace | jaq -r '.id') = "$ZEN_ID" ]; then
	hide
    fi

    socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
}




run
