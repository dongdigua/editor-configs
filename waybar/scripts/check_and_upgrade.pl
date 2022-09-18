#! /usr/bin/perl

$arg1 = @ARGV[0];

if ($arg1 eq "run") {
    DNFPackage(0);
    NixPackage(0);
    FlatPak(0);
    RustUp(0);
    CargoPackage(0);
}
else {
    $allnum =
        DNFPackage() +
        NixPackage() +
        FlatPak() +
        RustUp() +
        CargoPackage();
    print $allnum;
}


sub DNFPackage {
    if (scalar(@_) == 0) {
        system "doas dnf update";
        my $linenum = (`doas dnf check-update` =~ tr/\n//) - 1; # MAGIC from StackOverflow
        print "dnf: $linenum\n";
        return $linenum;
    }
    else {
        print `doas dnf upgrade`
    }
}

sub NixPackage {
    if (scalar(@_) == 0) {
        system "nix-channel --update";
        my $linenum = () = `nix-env -u --dry-run` =~ /^upgrading/;
        print "nix: $linenum\n";
        return $linenum;
    }
    else {
        print `nix-env -u`
    }
}

sub FlatPak {
    if (scalar(@_) == 0) {
        my $flatpaknum = () = `echo n | flatpak update` =~ /  U  /;
        print "flatpak: $flatpaknum\n";
        return $flatpaknum;
    }
    else {
        print `flatpak update -y`
    }
}

sub RustUp {
    if (scalar(@_) == 0) {
        if ((`rustup check` =~ tr/Up to date//) > 0) {
            print "rustup: no\n";
            return 0;
        }
        else {
            print "rustup: yes\n";
            return 1;
        }
    }
    else {
        print `rustup update`
    }
}

sub CargoPackage {
    if (scalar(@_) == 0) {
        my $cargonum = () = `cargo install-update --list` =~ /Yes$/; # yet another MAGIC from StackOverflow
        print "cargo: $cargonum\n";
        return $cargonum;
    }
    else {
        print `cargo install-update --all`
    }
}
