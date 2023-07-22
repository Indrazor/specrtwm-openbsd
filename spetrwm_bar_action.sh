#!/bin/ksh
# Openbsd spectrwm bar action
# hope you liked!
# x220 variables
# CPU_GHZ=2.8

# 󰉁 #flash 󰉃  #flash-off
#    #usb
# 󰈐 20000 󱪈 2002 󰖝 5000 #fan
#  #cpu 󰻠 #x64cpu
#  #ram
# 󰕾 #volume
# 󰖁 #volume-off
# 󰖪 #wifi-off
# 󱚵 #wifi-not-connected
# 󰖩 #wifi-connected
# 󰃟 #brillo
# 󰋊 #hard-disk
#  #wether
# 󰩠 #ip
#  #data-descarga
#  #data-subida
#  #puffy-pkg

## BATTERY
bat() {
    bat_percent="$(apm -l)"
    bat_hours="$(apm -m | awk '{print $1/60}')"
    power_suply="$(sysctl -n hw.sensors.acpiac0.indicator0 | awk '{print $1}')"
    if [ "$power_suply" = "On" ]; then
        batstat="󰉁${bat_percent}%"
    else
	    batstat="󰉃$(printf "%2.1f" "${bat_hours}")Hr"
    fi
    echo "$batstat"
    # echo "$batstat  $bat_percent %" #both
}

#temp max + NOTIFICATION 90C
temp() {
    temp_percent="$(sysctl -n hw.sensors.acpitz0.temp0 | awk '{print $1-1}')"
    echo "${temp_percent}°C"
}

#fan
fan() {
    fan_rpm="$(sysctl -n hw.sensors.acpithinkpad0.fan0 | awk '{print $1}')"
    echo "󰖝 ${fan_rpm}Rpm"
    # echo "󰖝 $(printf "%4.0f" ${fan_rpm})Rpm" #con 000
}

#packages
packages() {
    packages_info="$(pkg_info | wc -l)"
    echo " $(printf "%3.0f" "${packages_info}")"
}

#RAM
ram() {
    packages_info="$(vmstat | grep M | awk '{print $3-1}')"
    echo "$(printf "%4.0f" "${packages_info}")M"
} 

#DISK HOME
home() {
    d_info="$(df -h /home | awk -F "G" '{print $3}' | sed 's/ //g')"
    echo "󰋊$(printf "%4.0f" "${d_info}")G"
}

#packages

sound() {
    sonido_lev="$(sndioctl | grep output.level | awk -F "=" '{print $2*100}')"
    sonido_mut="$(sndioctl | grep output.mute | awk -F "=" '{print $2}')"
    if [ "$sonido_mut" = "0" ]; then
	    sonido_scr="󰕾 $(printf "%3.0f" "${sonido_lev}")%"
    else
        sonido_scr="󰖁 Mute"
    fi
    echo "$sonido_scr"
    
}

#MIC
mic() {
    mic_lev="$(sndioctl | grep input.level | awk -F "=" '{print $2*100}')"
    mic_mut="$(sndioctl | grep input.mute | awk -F "=" '{print $2}')"
    if [[ $mic_mut = 0 ]]; then
	mic_scr=" $(printf "%3.0f" "${mic_lev}")%"
    else
        mic_scr=" Mute"
    fi
    echo "$mic_scr"
}


#CPU GHz

cpu() {
    cpu1="$(sysctl -n hw.sensors.cpu0.frequency0 | awk '{print $1/2000000000}')"
    cpu2="$(sysctl -n hw.sensors.cpu2.frequency0 | awk '{print $1/2000000000}')"
        suma_cpu=$(awk "BEGIN{print $cpu1 + $cpu2}")
     #cpu_percent=$(($suma_cpu/2.8*100))
     #echo "  $(printf "%03.0f" "$cpu_percent")%"
     echo " $(printf "%3.1f" "${suma_cpu}")GHz"
}

## USB
usb() {
    usb_dir="/mnt/usb"
    if [ "$(ls -A $usb_dir)" ]; then
        usb_stat=" ${usb_dir} "
    else
        usb_stat=
    fi
    echo "$usb_stat"
}

## WIFI
wifi() {
	wifi_dir="$(ifconfig iwn0 | grep status | awk -F ": " '{print $2}')"
	if [[ $wifi_dir == active ]]; then
        wifi_stat="󰖩 ON!"
    else
	wifi_stat="󰖪 Off"
    fi
    echo "$wifi_stat"
}
light() {
    screen="$(xbacklight | awk -F "." '{print $1}')"
   # echo "󰉁${screen}%"
    echo "󰃟 $(printf "%3.0f" "${screen}")%"

}

# modules to use

while true; do
	echo "|$(cpu) $(ram) $(temp) $(fan) $(home) $(usb)$(packages) $(mic) $(sound) $(light) $(wifi) $(bat)|"	
    sleep 3
    wait
done



