#! /usr/bin/perl

$arg1 = $ARGV[0];
print $arg1;
$notify = "notify-send -t 500 ";

if ($arg1 eq "mute") {
    system "pactl set-sink-mute \@DEFAULT_SINK@ toggle";
    exec $notify . `pactl get-sink-mute \@DEFAULT_SINK@`;
}
elsif ($arg1 eq "mic") {
    system "pactl set-source-mute \@DEFAULT_SOURCE@ toggle";
    exec $notify . `pactl get-source-mute \@DEFAULT_SOURCE@`;
}
elsif ($arg1 eq "+") {
    system "pactl set-sink-volume \@DEFAULT_SINK@ +5%";
    `pactl get-sink-volume \@DEFAULT_SINK@` =~ /\d+%/;
    exec $notify . $&;
}
elsif ($arg1 eq "-") {
    system "pactl set-sink-volume \@DEFAULT_SINK@ -5%";
    `pactl get-sink-volume \@DEFAULT_SINK@` =~ /\d+%/;
    exec $notify . $&;
}
else { exec "notify-send", "invalid";}
