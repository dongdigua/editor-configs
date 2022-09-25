#! /usr/bin/perl
# version <= 9.2 don't need this
# modify org-insert-structure-template
# because modify (byte/source/naive)code is easiest way
# just capitalize begin & end
# I think newer version won't have other begin_%s end_%s code
# org version 9.5 now
# emacs 28 have eln(native) cache
# so need to modify source code

use PerlIO::gzip;

$bytecode = "org.elc";
$source = "org.el.gz";

modifySourceCode();

sub modifySourceCode {
    system "cp", $source, "$source.bak";
    system "rm", "~/.emacs.d/eln-cache/28*/org*.eln";

    open SOURCE, "<:gzip", "$source.bak" or die "$!";
    open SOURCE_M, ">:gzip", $source or die "$!";

    while (my $str = <SOURCE>) {
        $str =~ s/begin_%s/BEGIN_%s/;
        $str =~ s/end_%s/END_%s/;
        print SOURCE_M $str;
    }
    close SOURCE;
    close SOURCE_M;
}

sub modifyByteCode {
    open BYTECODE, "+<$bytecode" or die "$!";
    my $string = do { local $/; <BYTECODE> };

    $string =~ /\(defalias 'org-insert-structure-template/;
    my $match = $&;
    $match =~ s/begin_%s/BEGIN_%s/;
    $match =~ s/end_%s/END_%s/;

    print BYTECODE $`;
    print BYTECODE $match;
    print BYTECODE $';
    close BYTECODE;
}

