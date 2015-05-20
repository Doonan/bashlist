#!/bin/bash
#this script adds items to a list in a seperate text file
conf=list.txt		#name of config file
if [[ ! -f $conf ]]; then
	touch $conf		#creates config file if it doesn't exist
	echo conf file $conf created
fi

function help {		#this is the help message
	echo this is the 'bashlist' script help message
	echo this script maintains a list of things for you
	echo
	echo using -h or --help will display this message
	echo using -l or --list will read to you the list
	echo using -f or --fpop will remove the first item from the list
	echo using -b or --bpop will remove the first item from the list
	echo using no argument works the same as -c and --conf
	echo any other argument is read as input and added to the bottom of the list
	echo
	echo the list is kept in $conf in the directory this script is located in
	echo
}

if [ "$#" -gt 1 ]; then
    echo too many parameters
    help
elif [ -z "$1" ]; then
	while read l; do		#reading through list
		echo $l
	done <$conf
	exit
else
	if [ "$1" = -h ] || [ "$1" = --help ]; then		#catch for help option
		help
	elif [ "$1" = -l ] || [ "$1" = --list ]; then		#catch for list option
		while read l; do		#reading through list
			echo $l
		done <$conf
	elif [ "$1" = -f ] || [ "$1" = --fpop ]; then		#catch for fpop option
		if [[ -s $conf ]] ; then		#checking fo an empty list
			line=$(head -n 1 $conf)
			echo removing first entry, $line
			sed -i '' '1d' $conf		#mac osx way to use sed
		else
			echo list is empty
		fi;
	elif [ "$1" = -b ] || [ "$1" = --bpop ]; then		#catch for bpop option
		if [[ -s $conf ]] ; then		#checking fo an empty list
			line=$(tail -1 $conf | head -1)
			echo removing last entry, $line
			sed -i '' '$d' $conf		#mac osx way to use sed
		else
			echo config list is empty
		fi;
	else
		echo "$1" >> $conf		#adding argument to list
		echo "$1" added to conf file
	exit
	fi
fi