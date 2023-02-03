#! /bin/sh

print_date() {
    date '+%m/%d %H:%M'
}

print_temp() {
    sysctl -n hw.sensors.cpu0.temp0
}

print_volume() {
    if [ $(doas mixerctl outputs.master.mute) = 'on' ]; then
        echo "mute"
    else
        vol_line=$(doas mixerctl -n outputs.master | sed 's/,.*//')
        echo $vol_line
    fi
}

xsetroot -name "vol:$(print_volume) $(print_temp) $(print_date)"
