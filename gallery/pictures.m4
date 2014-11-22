#!/usr/bin/perl -w

use strict;
use File::Find ();
use CGI qw/:standard -debug/;

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats. 

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;

my $cgi = CGI->new;
print $cgi->header;
print <<EOF
paste(base.html)
EOF
if($cgi->param("dir"))
{
	my $dir = $cgi->param("dir");
	File::Find::find({wanted => \&wanted}, "/meta/g/grobe0ba/html/$dir");
}
else
{	
	File::Find::find({wanted => \&wanted}, '/meta/g/grobe0ba/html/');
}
print "</section></body></html>";

exit;

sub doprint
{
	my @name = @_;
	if($name =~ /site/){
	} else {
		$name =~ s/\/meta\/g\/grobe0ba\/html\///;
		my $base = File::Basename::basename($name);
print <<EOF
paste(element.html)
EOF		
	}
}


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    /^.*jpg\z/si
    && doprint($name);
}
