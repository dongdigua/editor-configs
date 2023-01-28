#! /bin/sh

print_date() {
    date '+%m/%d %H:%M'
}

print_temp() {
    sysctl -n hw.sensors.cpu0.temp0
}

while true
do
    xsetroot -name "$(print_temp) $(print_date)"
    sleep 5
done
