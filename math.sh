#!/usr/bin/env bash
#This script needs to run in bash and takes an argument e.g. "./math.sh 'myfilename'". It spits its output into the terminal, so you need to use redirection to put it in a file e.g. "./math.sh 'mfn' > outputfilename".

#We use the awesome program awk to read our nicely formatted text file and do some math and re-arranging. Awk works by looping over and over again row by row and was useful in calculating the change in variables with time.

#Let's disect it by 'paragraph':
#P1: We first tell awk that our files use a special seperator, and put it in the awk variable OFS
#P2: If the row number is one, then we're on the headers line and we should print off the headers
#P3: If the row number is two, we want to set all out 'previous' value to 0, since we assume they start at 0
#P4: If the row number is three, we want to print out column one of this row from the other file, and then column two minus its previous value. We set the 'previous' values to our current values for the next loop.
awk -v OFS='\t' \
	'NR==1 {print "Time", "ΔQuantity"}
	 NR==2 {prev=0}	\
	 NR >2 {print $1, $2-prev \
	       ;prev=$2}' < $1
#The "< $1" part is just where we send the contents of our file into awk
