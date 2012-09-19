#!/usr/bin/perl

use Data::Dumper;
my $m;

while(<>) {

    chomp;
    /(\d+)([ns])(\d+)([ew])\.png/ or next;

    my $x = $1;
    my $y = $3;

    ($2 eq 's') && do {$x--} || do {$x = -$x};
    ($4 eq 'e') && do {$y--} || do {$y = -$y};

    $m->{$x}{$y} = $_;
    print STDERR "I haz tile $x,$y on $_\n";

}

print STDERR Dumper($m);

print "<html><body><pre>";
for $x (-9 .. 20) {
for $y (-35 .. 31) {
    print (defined $m->{$x}{$y} ? "<a href=\"$m->{$x}{$y}\">#</a>" : ' ');
}
print "\n";
}
print "</pre></body></html>";
