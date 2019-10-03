# Change this according to your device
################
# Variables
################

# Keyboard input name
keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date=$(date "+%F")
# week=$(date "+w%-V")
current_time=$(date "+%R:%S")

#############
# Commands
#############

# Battery or charger
battery=$(upower --enumerate | grep 'BAT')
battery_charge=$(upower --show-info $battery | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $battery | egrep "state" | awk '{print $2}')
battery_upower=$(upower --show-info $battery | egrep "time to" | awk '{print $4}')
# battery_acpi=$(acpi -V | egrep -i "charging" | awk '{print $3  $4  $5}' | tr ',' ' ')

# Audio and multimedia
audio_sink=$(pactl list sinks short | awk '{print $1}')
audio_volume=$(pamixer --sink  $audio_sink --get-volume)
audio_is_muted=$(pamixer --sink $audio_sink --get-mute)
media_artist=$(playerctl metadata artist)
media_song=$(playerctl metadata title)
player_status=$(playerctl status)

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
# interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
network_ip=$(ip addr show dev $network | grep -Po '(?<=inet\s)(\w+\.)+\w+')
#ping=$(ping -c 1 www.archlinux.org | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)

# Others
language=$(swaymsg -r -t get_inputs |\
	awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' |\
	grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' |\
	grep "xkb_active_layout_name" |\
	awk -F '"' '{print $4}')

loadavg=$(cat /proc/loadavg | awk -F ' ' '{print $1" "$2" "$3}')
#loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')

if [ $battery_status = "discharging" ];
then
    battery_pluggedin='⚠'
else
    battery_pluggedin='⚡'
fi

if ! [ $network ]
then
   network_active="⛔"
else
   network_active="⇆"
fi

if [ "$player_status" = "Playing" ]
then
    song_status='▶'
elif [ "$player_status" = "Paused" ]
then
    song_status='⏸'
else
    song_status='⏹'
fi

if [ "$audio_is_muted" = "true" ]
then
    audio_active='🔇'
else
    audio_active='🔊'
fi

load="🏋"
phones="🎧"
kb="⌨"

echo "$phones $song_status $media_artist - $media_song | $kb $language | $network_active $network ($network_ip) | $load [ $loadavg ] | $audio_active $audio_volume% | $battery_pluggedin $battery_charge $battery_upower hrs | $date $current_time"
