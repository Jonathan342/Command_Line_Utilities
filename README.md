# Command_Line_Utilities
A set of utilities that are useful for command line (e.g. bash/zsh) manipulation of files

## mergeRow.pl

Prints the entirety of the first file, along with all rows from the second file that match it.If the second file has rows that do not match the first file,
they will not be printed, if more than one line from the second file match a single row from the first file, than all of those lines will be printed. If more than
one line from the first file match a line from the second file, the line from the second file will be printed twice
Example:
    
    perl mergeRow.pl -q 2 exposed_residues_2.tsv new_count.txt

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
    
There are other options, that you can see with the command `perl mergeRow.pl -h`

## MergeRow_iterative.py

This script merges rows of multiple files iteratively for multiple files, based on the files passed to it from the command line. 

This script depends on `mergeRow.pl` as well as the command `sponge`. All files must be tab delimited

Usage:
   
    mergeRow_iterative.py impute_value file_1.txt file_2.txt etc.

Example Usage:
   
    python mergeRow_iterative.py 0 file_1.txt file_2.txt file_3.txt

Note that you must give it an impute value, which will be printed if any values from file_1.txt are missing in subsequent files
    
For example, if file_1.txt has:

    josh 1
    aaron 2
    rachel 3

and file_2.txt has:
    
    josh 12
    aaron 57

and file_3.txt has:

    rachel 354
    aaron 763
    
Then this will produce:
    
    ID  file_1.txt  file_2.txt  file_3.txt
    
    josh    1           12         0
    
    aaron   2           57          363
    
    rachel  3           0           354
