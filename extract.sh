#!/usr/bin/env bash
#This is a bash program, so we need to ask env to run it in bash.

#This is an example of how to extract data from a set of files, as is useful with the MAESTRO software in radiation labs. Keep in mind that it spits its output into the terminal, so to put in a file just redirect it as follows "./extract > outputfilename". This program is safe to run as is, although it outputs gibberish.

#Example function that takes its first argument and puts it in a pipe, takes its second argument and uses it to calculate which line of the argument to grab and appends it to the command needed to extract that line, then looks for the string "Number = 12345", with the decimal and trailing numbers optional and returns it.
function Fna(){
	echo "$1" | sed $[1 + $2]'q;d' | sed 's/.*Number =  \([0-9]*\).*/\1/'
}
#Example function that takes its first argument and puts it in a pipe, takes the second second line of the argument, then looks for a line structured as "Number = 12345.12350", with the decimal and trailing numbers optional and returns it.
function Fnb(){
	echo "$1" | sed '2q;d' | sed 's/.*Number = \([0-9]\+\.\?[0-9]*\).*/\1/'
}


#We want a header to start with, separated by tabs. Adjacent strings automatically concatenate
echo -e "A" "\tB" "\tC"
#Look for .txt files in the current folder and put their name in fn. This is fairly dangerous if you intend to write to said files and they're not intended, but in this case we're simply reading them so it's fine.
for fn in *.txt; do
	#Inappropriate usage of the program cat, which reads the file name and puts it in the terminal. Notice the quotes.
	file=$(cat "$fn")
	#Write to the terminal the results of running Fna on the file contents, the -ne part means we don't want a new line, and we want special extensions.
	echo -ne $(Fnb "$file")"\t"
	#Write with a newline, tabspaced Fna 1 and Fna 2
	echo -e $(Fna "$file" 1)"\t"$(Fna "$file" 2)
#Alright, we're done here.
done
