#! /bin/sh

sed -i s/\/usr\/libexec\/polkit-gnome-authentication-agent-1//g  sway/config
sed -i s/libinput-gestures//g                                    sway/config
