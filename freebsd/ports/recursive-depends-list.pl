#!/usr/bin/perl

use strict;
use Data::Dumper;

my $depth=0;
my $prefix="   ";
my %portindex=();

sub getdep
{
	(my $KEY,undef)=@_;

	my @DEPS=split(/ /, $portindex{"$KEY"});

	foreach(@DEPS)
	{
		$prefix=~s/[\- |]/ /g;
		$prefix="$prefix|--";
		print "$prefix$_\n";
		getdep($_);
		$prefix=""
	}
}


open(my $INDEX_FILE, "< /usr/ports/INDEX-10") or die "Could not open INDEX file: $!\n";

while(defined(my $LINE=<$INDEX_FILE>))
{
	chomp $LINE;
	my @PORT = split(/\|/, $LINE);
	my $KEY=$PORT[0];
	my $VALUE="$PORT[7] $PORT[8]";

	$portindex{"$KEY"}=$VALUE;
}

if($ARGV[0])
{
	print "|--$ARGV[0]\n";
	getdep($ARGV[0]);
}
