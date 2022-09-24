#! /usr/bin/perl
# modify org.elc org-insert-structure-template
# because modify bytecode is easiest way
# capitalize begin & end
# version <= 9.2 don't need this
# org version 9.5 now

#$filename = "/usr/share/emacs/28.1/lisp/org/org.elc";
$filename = "org.elc";
system "cp", $filename, "$filename.bak";
open BYTECODE, "+<$filename" or die "open file error: $!";

$string = do { local $/; <BYTECODE> };

$string =~ /\(defalias 'org-insert-structure-template/;
$match = $&;
$match =~ s/begin_%s/BEGIN_%s/;
$match =~ s/end_%s/END_%s/;

print BYTECODE $`;
print BYTECODE $match;
print BYTECODE $';

close BYTECODE;
