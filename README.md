# Command_Line_Utilities
A set of utilities that are useful for command line (e.g. bash/zsh) manipulation of files

##selectRow.pl
Prints the entirety of the first file, along with all rows from the second file that match it.If the second file has rows that do not match the first file,
they will not be printed, if more than one line from the second file match a single row from the first file, than all of those lines will be printed. If more than
one line from the first file match a line from the second file, the line from the second file will be printed twice
Example:
    
    perl ~/jb3401/scripts/Utils/mergeRow.pl -q 2 exposed_residues_2.tsv new_count.txt

This merges exposed_residues_2.tsv new_count.txt looking to see which row entries from the third colum of exposed_residues_2.tsv match those from the first
column of new_count.txt

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
