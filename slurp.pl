#!/usr/bin/perl

use Data::Dumper;

my @todo = [1,-1];
my %cache;

sub name {
    my ($tx,$ty) = @{ $_[0] };
    return ($ty >= 0 ? (($ty+1).'s'):(-$ty).'n').( $tx >= 0 ? (($tx+1).'e'):(-$tx).'w');
}

sub neighbors {
    my ($x, $y) = @{$_[0]};
    return ([$x+1,$y], [$x-1,$y], [$x,$y+1], [$x,$y-1]);

}

while(@todo) {

    print STDERR scalar @todo, " jobs to do\n";
    #print STDERR "Todo: ", map { name($_), ',' } @todo, "\n";
    #print STDERR "Cache: ", Dumper(\%cache), "\n";

    my $tgt = shift @todo;
    my $target_name = name($tgt);

    my $r = 0;
    if (-e "$target_name.png") {
        print STDERR "$target_name.png already exists, pretending i fetched it\n";
    } else {    
        print STDERR "Fetching [$tgt->[0], $tgt->[1]] $target_name... ";
        system "wget http://imgs.xkcd.com/clickdrag/$target_name.png 2>/dev/null";
        $r = $?;
        print STDERR ($r == 0 ? "OK\n" : $r == 2048 ? "404\n" : "???\n");
    }



    if (!$r) { #success, add neighbors to todo list
        for (neighbors($tgt)) {
            if (!$cache{ name($_) }) {
                print STDERR "Adding new tile [$_->[0],$_->[1]]\n";
                push @todo, $_;
                $cache{ name($_)} = 1;
            } else {
                print STDERR "Skipping cached tile [$_->[0],$_->[1]]\n";
            }
        }
    }

}
