#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;

my $path=shift(@ARGV) or die "No path provided\n";
my $output=shift(@ARGV) or die "No output file provided\n";
open(FILE_OUTPUT, ">", $output);

my @files = <$path/*>;
print "Parsing $path\n";


print FILE_OUTPUT "Test name,Total time (ms),Graal Rules,Graal Atoms,Graal AtomSets,Graal Queries,Graal Constraints,PDQ rules,Discarded rules,Completed,Rewriting size,Solver total time (ms),Solver out,Solver err,Solver atoms,\n";

my $ncompleted = 0;
foreach my $file (@files) {

    my ($name, $filepath, $suffix) = fileparse($file, qr{\.[^.]*$});
#     print "$name $suffix\n";
    
    open(my $fh, "<", $file) or die "cannot open < $file: $!";
    
    my $total_time = "~";
    my $total_time_ms = "-";
    my $n_discarded_rules = "";
    my $pdq_rules = "";
    my $graal_data = "";
    my $n_graal_rules = "";
    my $n_graal_atoms = "";
    my $n_graal_atomsets = "";
    my $n_graal_queries = "";
    my $n_graal_constraints = "";
    my $discarded_rules = "";
    my $completed = "NO :(";
    my $solver_total_time = "~";
    my $solver_total_time_ms = "-";
    my $solver_output = "";
    my $solver_out = "";
    my $solver_err = "";
    my $pfg = 0;
    my $solver_atoms = "";
    my $counter = 0;
    my $start_counter = 0;
    
    while (<$fh>) {

        chomp();
        
        if (/(GSat total time : (\d+).+)/) {
            $total_time = $1;
            $total_time_ms = $2;
        } elsif (/(GSat discarded rules : (\d+)\/(\d+).+)/) {
            $discarded_rules = $1;
            $n_discarded_rules = $2;
            $pdq_rules = $3;
        } elsif (/Rewriting completed!/) {
            $completed = "YES :)";
            $ncompleted++;
        } elsif (/(# Rules: (\d+); # AtomSets: (\d+))/) {
            $graal_data = $1;
            $n_graal_rules = $2;
            $n_graal_atoms = $3;
        } elsif (/(# Rules: (\d+); # Atoms: (\d+); # AtomSets: (\d+); # Queries: (\d+); # Constraints: (\d+))/) {
            $graal_data = $1;
            $n_graal_rules = $2;
            $n_graal_atoms = $3;
            $n_graal_atomsets = $4;
            $n_graal_queries = $5;
            $n_graal_constraints = $6;
        } elsif (/Performing the full grounding/) {
            $pfg = 1;
        } elsif (/(Solver total time : (\d+).+)/ and $pfg) {
            $solver_total_time = $1;
            $solver_total_time_ms = $2;
        } elsif (/(Output size: (\d+), (\d+).+ (\d+))/ and $pfg) {
            $solver_output = $1;
            $solver_out = $2;
            $solver_err = $3;
            $solver_atoms = $4;
        } elsif (/======/) {
            if ($counter) {
                $start_counter = 0;
            } else {
                $start_counter = 1;
            }
        } elsif ($start_counter) {
            $counter += 1;
        }
        
        
    }
    
    print "$name\n$total_time\nGraal: $graal_data\n$discarded_rules\n$completed\nOutput:$counter\n$solver_total_time\n$solver_output\n\n";
    
    print FILE_OUTPUT "$name,$total_time_ms,$n_graal_rules,$n_graal_atoms,$n_graal_atomsets,$n_graal_queries,$n_graal_constraints,$pdq_rules,$n_discarded_rules,$completed,$counter,$solver_total_time_ms,$solver_out,$solver_err,$solver_atoms,\n";

    close $fh or warn "close failed: $!";
    
}

print "Completed: $ncompleted/". @files . "\n\n";

close FILE_OUTPUT or warn "close failed: $!";
