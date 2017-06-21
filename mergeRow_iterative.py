#!/usr/bin/python
#This script functions in a similair way to mergeRow.pl, except that it merges multiple files, one after the other to use it (for example):
#python /ifs/home/c2b2/bh_lab/jb3401/jb3401/scripts/Utils/mergeRow_iterative.py 1 PrePPI_neighborhood.txt CINDy_neighborhood.txt ARACNe_neighborhood.txt VIPER_neighborhood.txt > Combined_matrix.txt

#All files must be tab delimited
#the first number is the imputation. I.e. if the corresponding file does not have the entrance , what number should it do
#For example, if file_1.txt has:
#josh 1
#aaron 2
#rachel 3

#and file_2.txt has:
#josh 12
#aaron 57

#and file_3.txt has:
#rachel 354
#aaron 763

#then python /ifs/home/c2b2/bh_lab/jb3401/jb3401/scripts/Utils/mergeRow_iterative.py 0 file_1.txt file_2.txt file_3.txt will produce (note that zero is the imputation):
#josh 1 12 0
#aaron 2 57 363
#rachel 3 0 354

from __future__ import print_function
import sys;
import os;
from random import random
import socket;
import re;
import math;
import subprocess;
sys.argv.pop(0);
impute=sys.argv.pop(0);
file_1=sys.argv.pop(0);
file_1_orig=file_1
#print(file_1)
random_number=random()
util_file="util_file_"+str(random_number)
#print(util_file)
for i in sys.argv:
	#print(i)
	other_file=i;
	#Change to fit location of mergeRow.pl
	cmd=r"""{LOCATION}/mergeRow.pl -nf file_1 other_file|sponge util_file"""
	#print(cmd)
	cmd=cmd.replace("util_file",util_file)
	cmd=cmd.replace("file_1",file_1)
	cmd=cmd.replace("other_file",other_file)
	
	#print(cmd)
	os.system("{cmd}".format(**locals()))
	cmd=r"""cat util_file|colCount.pl |sort --general-numeric-sort --reverse|uniq|head --lines=1"""
	cmd=cmd.replace("util_file",util_file)
	#print(cmd)
	col_count_max=os.popen("{cmd}".format(**locals())).read()
	#col_count_max=col_count_max.argv.pop(0)
	#col_count_max=col_count_max[0]
	col_count_max=col_count_max.rstrip();
	#print(col_count_max)
	cmd=r"""cat util_file|perl -ne 'chomp $_; @v=split /\t/,$_;unless(exists $v[col_count_max-1]){$v[col_count_max-1]=impute;}$v_s=join "\t",@v;print "$v_s\n"'|sponge util_file"""
	cmd=cmd.replace("util_file",util_file)
	cmd=cmd.replace("col_count_max",col_count_max)
	cmd=cmd.replace("impute",impute)
	#print(cmd)
	os.system("{cmd}".format(**locals()))
	file_1=util_file
	#print(file_1)

print("ID",file_1_orig,*sys.argv,sep="\t",end="\n")
with open(util_file) as f:
    for line in f:
        print(line,end="")

#Cleanup
os.system("rm {util_file}".format(**locals()))
