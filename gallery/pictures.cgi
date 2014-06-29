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
print "
							<!DOCTYPE html>
		\n				<html lang=\"en\">
		\n\t					<head>
		\n\t\t					<title>grobe0ba's pictures</title>
		\n\t\t					<style type=\"text/css\">
		\n\t\t\t					.container {
		\n\t\t\t\t					width: 100%;
		\n\t\t\t					}
		\n\t\t\t					.row {
		\n\t\t\t\t					width: 100%;
		\n\t\t\t					}
		\n\t\t\t					.col {
		\n\t\t\t\t					float: left;
		\n\t\t\t\t					height: 204px;
		\n\t\t\t\t					margin: 2px;
		\n\t\t\t\t					display: table;
		\n\t\t\t\t					border: 1px solid #555;
		\n\t\t\t\t					padding: 5px;
		\n\t\t\t\t					width: 70%;
		\n\t\t\t					}
		\n\t\t\t					.col p {
		\n\t\t\t\t					display: table-cell;
		\n\t\t\t\t					vertical-align: middle;
		\n\t\t\t					}
		\n\t\t\t					.left {
		\n\t\t\t\t					width: 25%;
		\n\t\t\t\t					text-align: center;
		\n\t\t\t					}
		\n\t\t\t					.clear {
		\n\t\t\t\t					clear: both;
		\n\t\t\t\t					}
		\n\t\t\t\t					.col img { margin: 0 auto 0 auto; }
		\n\t\t\t\t					.col right { width: 75%; }
		\n\t\t					</style>
		\n\t					</head>
		\n\t					<body>
		\n\t\t					<section class=\"container\">
";
if($cgi->param("dir"))
{
	my $dir = $cgi->param("dir");
	File::Find::find({wanted => \&wanted}, "/meta/g/grobe0ba/html/$dir");
}
else
{	
	File::Find::find({wanted => \&wanted}, '/meta/g/grobe0ba/html/');
}
print "
		\t\t						</section>
		\t						</body>
		\n				</html>
";
exit;

sub doprint
{
	my @name = @_;
	if($name =~ /site/){
	} else {
		$name =~ s/\/meta\/g\/grobe0ba\/html\///;
		my $base = File::Basename::basename($name);
		print "
			\n\t\t\t			<section class=\"row\">
			\n\t\t\t\t			<section class=\"col left\"><p><a id=\"$base\" href=\"http://grobe0ba.sdf.org/$name\"><img src=\"http://grobe0ba.sdf.org/thumbnail.cgi?name=$name\" alt=\"$name\" /></a></p></section>
			\n\t\t\t\t			<section class=\"col\"><p><a href=\"http://grobe0ba.sdf.org/$name\">$name</a></p></section>
			\n\t\t\t\t			<div class=\"clear\"></div>
			\n\t\t\t			</section>
		";
	}
}


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    /^.*jpg\z/si
    && doprint($name);
}
