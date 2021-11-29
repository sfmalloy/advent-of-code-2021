#!usr/bin/perl
use warnings;
use strict;

sub doAdd {
    return $_[0] + $_[1];
}

print("Hello from Perl!\n");
printf("a + b = %d\n", doAdd(1, 2));
