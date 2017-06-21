#!/usr/bin/perl
use warnings;
use strict;

use File::Basename;
use Getopt::Long;
#merge rows of two files
#options:delimitor,columnid to merge on
=comment
Prints the entirety of the first file, along with all rows from the second file that match it.If the second file has rows that do not match the first file,
they will not be printed, if more than one line from the second file match a single row from the first file, than all of those lines will be printed. If more than
one line from the first file match a line from the second file, the line from the second file will be printed twice
Example:
#	 perl ~/jb3401/scripts/Utils/mergeRow.pl -q 2 exposed_residues_2.tsv mutations/kras_mutations_new_count.txt

This merges exposed_residues_2.tsv with mutations/kras_mutations_new_count.txt looking to see which row entries from the third colum of exposed_residues_2.tsv match those from the first
column of mutations/kras_mutations_new_count.txt

Alternativley (using the -s option), you can use this script to combine the lines of just one file, but you can only do this for the first column, For example, if your file had the following lines

100     F5GWI4
100     P00813
1000    A8MWK3
1000    P19022
10000   Q9Y243
10001   B4DU17
10001   B4E2P0
10001   O75586
10002   B6ZGU0
10002   Q9Y5X4
10002   F1D8Q9
10005   O14734
10005   E9PRD4

Using the -s option will produce:

100     F5GWI4  P00813
1000    A8MWK3  P19022
10000   Q9Y243
10001   B4DU17  B4E2P0  O75586
10002   B6ZGU0  Q9Y5X4  F1D8Q9
10005   O14734  E9PRD4

Note that you can use the -d option with -s ,but not -q or -f 
=cut
my $prog = basename ($0);
my $colid="0";
my $colid_2="0";
my $delim = "\t";
my $single;
my $merge="\t";
my $excluded;
my $no_first;
my $empty_message;
GetOptions ('q|query-column-id:i'=>\$colid,
                'd|delimitor:s'=>\$delim,
                'f|filter-column-id:i'=>\$colid_2,
                's|single'=>\$single,
                'm|merge:s'=>\$merge,
                'x|excluded'=>\$excluded,
                'nf|no-first'=>\$no_first,
                'em|empty-message'=>\$empty_message,
);
if (@ARGV < 1)
{
        print "Merge rows from two files\n";
        print "Usage: $prog [options] <input-file> (<input-file>)\n";
        print "OPTIONS:\n";
        print " -q [int] : column id (zero-based) of file 1 to merge on (default=$colid)\n";
        print " -f [int] : column id of second column to merge on (default=$colid_2)\n";
        print " -d       : delimitor (tab)\n";
        print " -s       : combine the rows of a single file, not two files, only works for first column\n";
        print " -m       : The delimitor for merging the lines\n";
        print " -x       : Only print rows that have no corresponding line in the other file\n";
        print " -nf 	 : When merging the rows, don't print the first element of the  added row\n";
        print " -em 	 : If the line does not have a corresponding one, print NA on the line\n";
        exit (1);
}
if ($empty_message){
	$empty_message="NA";
}
unless ($single){
	my @file1=`cat $ARGV[0]`;
	my @file2=`cat $ARGV[1]`;
	my %hash1;
	my %hash2;

	foreach (@file1){
		chomp $_;
		my @a=split /$delim/,$_;
		$hash1{$_}=$a[$colid];

	}
	foreach (@file2){
		chomp $_;
		my @a=split /$delim/,$_;
		my $a=\@a;
		my @b;
		if (exists $hash2{$a[$colid_2]}){$b=$hash2{$a[$colid_2]};@b=@{$b};}
		push (@b,$a);
		my $b=\@b;
		$hash2{$a[$colid_2]}=$b;
		next;
	}
	foreach (@file1){
		chomp $_;
		my @a=split /$delim/,$_;
		my $line=$_;
		my $addition;
		my $flag=1;
		if (exists $hash2{$a[$colid]}){$addition=&add_to_line($hash2{$a[$colid]},$delim);}
		#else{$addition;}
		
	#	if (!$addition or ($addition eq '') or $addition=~/^\s*$/){
	#		$flag=1;
	#	}
	#	if ($excluded and $flag==1){
	#		print "$line\n";
	#		next;
	#	}
		#if (!$addition  and $excluded){
		#	$line=$line;
		#}
		if ($addition){
			if ($no_first){
				my @addition=split /$delim/,$addition;
				shift @addition;
				$addition=join "$delim",@addition;
			}
			$line=$line."$merge".$addition;
		}
		elsif(!$addition){
			$line=$line;
			if ($empty_message){
				$line=$line."$merge".$empty_message;
			}
		}
		if($addition and $excluded){
			$flag=0;
		}
		if ($flag){print "$line\n";}

	}
}
if ($single){
	#merge the single file based on rows, only uses column 1.
	my $filename=shift;
	#@line=@{\@line};
	open IN, '<', $filename or die $!;
	my %hash;
	foreach (<IN>){
		chomp $_;
		my @a=split /$delim/,$_;
		my $a_first=shift @a;
		my $a_s=join "$delim",@a;
		if ($hash{$a_first}){$hash{$a_first}=$hash{$a_first}."$merge".$a_s;}
		else{$hash{$a_first}=$a_s;}

	}
	close IN;
	open IN, '<', $filename or die $!;
	my %hash1;
	foreach (<IN>){
		chomp $_;
		my @a=split /$delim/,$_;
		my $a_first=shift @a;
		my $result=$hash{$a_first};
		if (!defined $hash1{$a_first}){
			print "$a_first\t$result\n";
			$hash1{$a_first}=1;
	}
	

}
}

exit;
sub add_to_line{
	my $a=shift @_;
	my @a=@{$a};
	my $delim=shift @_;
	my @addition;
	foreach my $b (@a){
		my @b=@{$b};
		my $bs=join "$delim",@b;
		push (@addition,$bs);
	}
	my $addition=join "$delim",@addition;
	return $addition;
}
