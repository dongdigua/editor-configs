#! /usr/bin/perl
# just try some perl

$base_dir = "~/Pictures/wallpaper/";
@list = (
    "miku-wallpaper-modified.jpg",
    "centos7-bg.jpg",
    "crystal-water.jpg",
    "plain-flower.png",
    "beautiful-ocean.jpg",
    "f37-day.png",
    "mikee.png",
    "golden-field.png",
    "win11.jpg",
    "centos9-motif.png",
    "Cardinali.jpg",
    "debian9-softwaves.png",
    "f38-day.jpg",
);

$ps = `ps l | grep swaybg`;
$arg1 = $ARGV[0];

if ($arg1 eq "-random") {
    while (true) {
        $random_one = @list[int(rand(scalar @list))];
        if ($ps !~ /$random_one/) {
            system("swaymsg output '* bg $base_dir$random_one fill'");
            last;
        }
    }
}
else {
    foreach $w (@list) {
        if ($arg1 eq $w) {
            system("swaymsg output '* bg $base_dir$w fill' > /dev/null");
            print "$w\n"
        }
        else {
            print "$w\n"
        }
    }
}
