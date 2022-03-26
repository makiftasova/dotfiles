#! /usr/bin/env bash

##############
# Functions
##############

# startswith() { case $1 in "$2"*) true;; *) false;; esac; }

# Change this according to your device
################
# Variables
################

# Keyboard input name
# keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date="$(date "+%F %A")"
current_time="$(date "+%T")"

#############
# Commands
#############

# Battery or charger
battery="$(upower --show-info "$(upower --enumerate | grep 'BAT')" | grep -v 'failed')"
if [ -n "$battery" ]; then
	battery_charge=$(echo "$battery" | grep -E "percentage" | awk '{print $2}')
	battery_status=$(echo "$battery" | grep -E "state" | awk '{print $2}')
	battery_time=$(echo "$battery" | grep -E "time to" | awk '{print $4, $5}')
	# convert 'minutes'->'mins' and 'hours'->'hrs'
	battery_time=$(echo "$battery_time" | tr -d 'oute')
	if [ "$battery_status" = "discharging" ]; then
		battery_pluggedin='⚠'
	else
		battery_pluggedin='⚡'
	fi
	battery_output="$battery_pluggedin $battery_charge $battery_time"
else
	battery_output="No Battery"
fi
# battery_acpi=$(acpi -V | egrep -i "charging" | awk '{print $3  $4  $5}' | tr ',' ' ')

# Audio and multimedia

# audio_sink="$(pactl list sinks short| grep "$(pactl get-default-sink)" | awk '{print $1}')"

audio_volume=$(pamixer --sink '@DEFAULT_SINK@' --get-volume)

audio_is_muted=$(pamixer --sink '@DEFAULT_SINK@' --get-mute)
case "$audio_is_muted" in
	true )
		audio_active='🔇'
		;;
	* )
		audio_active='🔊'
		;;
esac

media_artist=$(playerctl metadata artist 2>/dev/null)

media_song=$(playerctl metadata title 2>/dev/null)

player_status=$(playerctl status 2>/dev/null)
case "$player_status" in
	Playing )
		song_status='▶'
		;;
	Paused )
		song_status='⏸'
		;;
	* )
		song_status='⏹'
		;;
esac

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
network_ip='0.0.0.0/0'
#ping=$(ping -c 1 www.archlinux.org | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
#wifi_ssid=$(nmcli dev wifi list --rescan no | grep -e "^*" | cut -f8 -d ' ')
network_info=$(nmcli dev show "$network")
network_type=$(echo "$network_info" | grep "TYPE" | awk '{split($0,a,":"); gsub("(^[ \t]+)|([ \t]+$)", "", a[2]); print a[2]}')
if [ "$network_type" = "wifi" ]; then
	wifi_ssid=": $( echo "$network_info" | grep "CONNECTION" | awk '{split($0,a,":"); gsub("(^[ \t]+)|([ \t]+$)", "", a[2]); print a[2]}')``"
fi

if [ -n "$network" ]; then
	network_active="⇆"
	network_ip=$(ip addr show dev "$network" | grep -Po '(?<=inet\s)(\w+\.)+\w+/\d+')
else
	network_active="⛔"
fi

# Others
language="$(swaymsg -r -t get_inputs | jq '.[] | select(.type="keyboard").xkb_active_layout_name | select( . != null)' | uniq | tr -d '"')"

loadavg=$(awk -F ' ' '{print $1" "$2" "$3}' < /proc/loadavg)

load="🏋"
phones="🎧"
kb="⌨"

echo "$phones $song_status $media_artist - $media_song | $kb $language | $network_active $network $wifi_ssid ($network_ip) | $load [ $loadavg ] | $audio_active $audio_volume% | $battery_output | $date $current_time"
