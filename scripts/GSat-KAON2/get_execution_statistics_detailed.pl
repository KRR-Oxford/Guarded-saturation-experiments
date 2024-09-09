#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;

my $path=shift(@ARGV) or die "No path provided\n";
my $output=shift(@ARGV) or die "No output file provided\n";
open(FILE_OUTPUT, ">", $output);

my @files = <$path/*>;
print "Parsing $path\n";

my $previous_default = select(STDOUT);  # save previous default
$|++;                                   # autoflush STDOUT
select(STDERR);
$|++;                                   # autoflush STDERR, to be sure
select(FILE_OUTPUT);
$|++;                                   # autoflush FILE_OUTPUT
select($previous_default);              # restore previous default


print FILE_OUTPUT "Test name,File name,# rules KAON2,Total Time KAON2 (ms),# rules GSat,Total Time GSat (ms),GSat Final State,KAON2 Final State,KAON2Exception?,Terminated,Failed,Graal Rules,Graal Atoms,Graal AtomSets,Graal Queries,Graal Constraints,PDQ rules,Discarded rules,Initial Axioms\n";

my $ncompletedGSat = 0;
my $ncompletedKAON2 = 0;
foreach my $file (@files) {

    my ($name, $filepath, $suffix) = fileparse($file, qr{\.[^.]*$});
    print "Processing file $name\n";
    
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
    my $GSatData = 0;
    my $KAON2Data = 0;
    my $GSatFinalState = "OK";
    my $KAON2FinalState = "OK";
    my $discarded_rules = "";
    my $n_discarded_rules = "";
    my $pdq_rules = "";
    my $initial_axioms = "";
    my $n_initial_axioms = "";
    
    while (<$fh>) {

        chomp();
        
        if (/(Summary:(.+?);(\d+);(\d+);(\d+);(\d+))/) {
            $summary = $1;
            $file_name = $2;
            $rulesKAON2 = $3;
            $timeKAON2 = $4;
            $rulesGSat = $5;
            $timeGSat = $6;
        } elsif (/(GSat discarded rules : (\d+)\/(\d+).+)/) {
            $discarded_rules = $1;
            $n_discarded_rules = $2;
            $pdq_rules = $3;
        } elsif (/(KAON2Exception)/) {
            $KAON2Exception = $1;
        } elsif (/(Terminated!)/) {
            if ($GSatData) {
                $GSatFinalState = "Terminated!"
            } elsif ($KAON2Data) {
                $KAON2FinalState = "Terminated!"
            } else {
                warn "ERROR!!!";
            }
            $Terminated += 1;
        } elsif (/Failed!/) {
            if ($GSatData) {
                $GSatFinalState = "Failed!"
            } elsif ($KAON2Data) {
                $KAON2FinalState = "Failed!"
            } else {
                warn "ERROR!!!";
            }
            $Failed += 1;
        } elsif (/GSat Start/) {
            $GSatData = 1;
        } elsif (/GSat End/) {
            $GSatData = 0;
        } elsif (/KAON2 Start/) {
            $KAON2Data = 1;
        } elsif (/KAON2 End/) {
            $KAON2Data = 0;
        } elsif (/(# Rules: (\d+); # Atoms: (\d+); # AtomSets: (\d+); # Queries: (\d+); # Constraints: (\d+))/) {
            $graal_data = $1;
            $n_graal_rules = $2;
            $n_graal_atoms = $3;
            $n_graal_atomsets = $4;
            $n_graal_queries = $5;
            $n_graal_constraints = $6;
        } elsif (/(Initial axioms in the ontology: (\d+))/) {
            $initial_axioms = $1;
            $n_initial_axioms = $2;
        }
        
    }


    $ncompletedGSat += 1 if $GSatFinalState eq "OK";
    $ncompletedKAON2 += 1 if $KAON2FinalState eq "OK";
    
    print "$name\n$summary\nGSat Final State: $GSatFinalState\nKAON2 Final State: $KAON2FinalState\n#Terminated: $Terminated\n#Failed: $Failed\n$graal_data\n$discarded_rules\n$initial_axioms\n\n";
    
    print FILE_OUTPUT "$name,$file_name,$rulesKAON2,$timeKAON2,$rulesGSat,$timeGSat,$GSatFinalState,$KAON2FinalState,$KAON2Exception,$Terminated,$Failed,$n_graal_rules,$n_graal_atoms,$n_graal_atomsets,$n_graal_queries,$n_graal_constraints,$pdq_rules,$n_discarded_rules,$n_initial_axioms\n";
    
    close $fh or warn "close failed: $!";
    
}

print "Completed: KAON2: $ncompletedKAON2/". @files . ", GSat: $ncompletedGSat/". @files . "\n\n";

close FILE_OUTPUT or warn "close failed: $!";
