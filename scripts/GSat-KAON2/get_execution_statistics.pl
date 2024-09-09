#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;

my $path=shift(@ARGV) or die "No path provided\n";
my $output=shift(@ARGV) or die "No output file provided\n";
open(FILE_OUTPUT, ">", $output);

my @files = <$path/*>;
print "Parsing $path\n";


print FILE_OUTPUT "Test name,File name,# rules KAON2,Total Time KAON2 (ms),# rules GSat,Total Time GSat (ms),KAON2Exception?,Terminated,Failed,Graal Rules,Graal Atoms,Graal AtomSets,Graal Queries,Graal Constraints\n";

my $ncompleted = 0;
foreach my $file (@files) {

    my ($name, $filepath, $suffix) = fileparse($file, qr{\.[^.]*$});
#     print "$name $suffix\n";
    
    open(my $fh, "<", $file) or die "cannot open < $file: $!";
    
    my $summary = "";
    my $file_name = "";
    my $rulesKAON2 = "";
    my $timeKAON2 = "";
    my $rulesGSat = "";
    my $timeGSat = "";
    my $KAON2Exception = "NO";
    my $Terminated = 0;
    my $Failed = 0;
    my $graal_data = "";
    my $n_graal_rules = "";
    my $n_graal_atoms = "";
    my $n_graal_atomsets = "";
    my $n_graal_queries = "";
    my $n_graal_constraints = "";
    
    while (<$fh>) {

        chomp();
        
        if (/(Summary:(.+?);(\d+);(\d+);(\d+);(\d+))/) {
            $summary = $1;
            $file_name = $2;
            $rulesKAON2 = $3;
            $timeKAON2 = $4;
            $rulesGSat = $5;
            $timeGSat = $6;
        } elsif (/(KAON2Exception)/) {
            $KAON2Exception = $1;
        } elsif (/(Terminated!)/) {
            $Terminated += 1;
        } elsif (/Failed!/) {
            $Failed += 1;
        } elsif (/(# Rules: (\d+); # Atoms: (\d+); # AtomSets: (\d+); # Queries: (\d+); # Constraints: (\d+))/) {
            $graal_data = $1;
            $n_graal_rules = $2;
            $n_graal_atoms = $3;
            $n_graal_atomsets = $4;
            $n_graal_queries = $5;
            $n_graal_constraints = $6;
        }
        
    }
    
    print "$name\n$summary\n$KAON2Exception\n$Terminated\n$Failed\n$graal_data\n\n";
    
    print FILE_OUTPUT "$name,$file_name,$rulesKAON2,$timeKAON2,$rulesGSat,$timeGSat,$KAON2Exception,$Terminated,$Failed,$n_graal_rules,$n_graal_atoms,$n_graal_atomsets,$n_graal_queries,$n_graal_constraints\n";

    close $fh or warn "close failed: $!";
    
}

print "Completed: $ncompleted/". @files . "\n\n";

close FILE_OUTPUT or warn "close failed: $!";
