#!/usr/bin/perl -w

use strict;
use warnings;

use CGI qw/:standard -debug/;

my $cgi = CGI->new;
my $name=$cgi->param("name");
open(my $fin, "mogrify -write - -thumbnail 200x200 \"/meta/g/grobe0ba/html/$name\" |") or die("Could not mogrify: $!");
print $cgi->header("image/jpeg");
while(defined (my $in=<$fin>))
{
	print $in;
}
close $fin;
