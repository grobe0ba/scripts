#!/usr/bin/perl

use strict;
use Digest::SHA qw(sha256_hex);

my $depth=0;
my $prefix=sha256_hex($ARGV[0]);
$prefix=~s/[0-9]//g;
my %portindex=();
my $out;

sub getdep
{
    $depth+=1;
	(my $KEY,undef)=@_;

	my @DEPS=split(/ /, $portindex{"$KEY"});

	foreach(@DEPS)
	{
		if ($_ eq "" )
		{
			print $out "$prefix\n";
		}
		else
		{
		    $prefix="$prefix->";
		    my $lout = sha256_hex($_);
		    $lout =~s/[0-9]//g;
		    $prefix="$prefix$lout";
		    print $out "$lout [constraint=true,label=\"$_\"];\n";
		    getdep($_);
		}
		($prefix,undef)=split(/->/, $prefix);
	}
    $depth-=1;
}

sub uniq { my %seen; grep !$seen{$_}++, @_ }


open(my $INDEX_FILE, "< /usr/ports/INDEX-11") or die "Could not open INDEX file: $!\n";

while(defined(my $LINE=<$INDEX_FILE>))
{
	chomp $LINE;
	my @PORT = split(/\|/, $LINE);
	my $KEY=$PORT[0];
	my $VALUESTRING="$PORT[7] $PORT[8]";

	my @VALUEARRAY=split(/ /, $VALUESTRING);

	@VALUEARRAY=uniq(@VALUEARRAY);

	my $VALUE=join(" ", @VALUEARRAY);

	$portindex{"$KEY"}=$VALUE;
}

if($ARGV[0] && $ARGV[1])
{
    open($out, "| tred | dot > $ARGV[1]") or die "Could not open output file: $!\n";
    print $out "digraph A {\n";
    print $out "$prefix [label=\"$ARGV[0]\"];\n";
    getdep($ARGV[0]);
    print $out "}\n";
}
else
{
    print "Usage: recursive-depends-list-dot.pl [port] [output.svg]\n";
    print "port should be in the form port-version (e.g., subversion-1.8.10_3)\n";
    print "You can find this by moving to the port directory and running:\n";
    print "\tmake describe|cut -d'|' -f1\n";
    print "This script requires dot and tred from graphviz to be available.\n";
}
