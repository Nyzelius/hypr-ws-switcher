#!/bin/sh
# ws-switch.sh
# Forked on December 19, 2024 from https://github.com/jasper-clarke/hypr-ws-switcher

# Set the number of workspaces per screen
ws_per_monitor=10

monitor=$(hyprctl activeworkspace | sed -n 's/.*monitorID:\s\([0-9]\+\).*/\1/p')
exclude='\(\sDP\)'

calc=$(($1 + (ws_per_monitor * monitor)))

case $2/$3 in
move/)
	hyprctl dispatch movetoworkspace "$calc"
	;;
move/other)

	if [ -n "$4" ]; then
		calc="$4"
	else
		read -r calc <<EOF
  $(echo "$1 + $ws_per_monitor * ( ($monitor+1)%$(hyprctl monitors | grep -v "${exclude:-'^$'}" | grep -c '^Monitor') )" | bc)
EOF
	fi

	hyprctl dispatch movetoworkspace "$calc"
	;;
*)
	hyprctl dispatch workspace "$calc"
	;;
esac
