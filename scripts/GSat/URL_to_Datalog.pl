#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my $path=shift(@ARGV) or die "No path provided\n";
open(FILE_OUTPUT, ">datalog.data");

my @files = <$path/*>;
print "Parsing $path\n";
foreach my $file (@files) {
    my ($name, $path,$suffix) = fileparse($file, qr{\.[^.]*$});
    print "$name $suffix\n";
    
     open(my $fh, "<", $file) or die "cannot open < $file: $!";
while (<$fh>)
{

	chomp();

    #   print $_ . "\n";
    $name =~ tr/A-Z/a-z/;

    my @fields = split(/,/, $_);
    print FILE_OUTPUT $name . '("' . join('","', @fields) . '").' . "\n";

	# if($_ =~ /Date: (.+)/)
	# {
	# 	$last_date = $1;
	# }
	
	# if($_ =~ /<((\w|\.|%|\+|-)+@(\w|\.|-)+(\w){2,4})>:/)
	# {
	# 	if($1 !~ /migg/ && $1 ne $last_email_address)
	# 	{
	# 		$last_email_address = $1;
	# 		print FILE_OUTPUT "$last_date;$last_email_address\n";
	# 	}
	# }
	
}
    close $fh or warn "close failed: $!";
}

close FILE_OUTPUT or warn "close failed: $!";