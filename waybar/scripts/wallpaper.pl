#! /usr/bin/perl
# just try some perl

$base_dir = "~/Pictures/wallpaper/";
@list = (
    "miku-wallpaper-modified.jpg",
    "centos.jpg",
    "crystal-water.jpg",
);

$ps = `ps l | grep swaybg`;
while (true) {
    $random_one = @list[int(rand(scalar @list))];
    if ($ps !~ /$random_one/) {
        last;
    }
}
system("swaymsg output '* bg $base_dir$random_one fill'");
