#!/bin/bash
#this script adds items to a list in a seperate text file
conf=$HOME/.list.txt		#name of config file
if [[ ! -f $conf ]]; then
	touch $conf		#creates config file if it doesn't exist
	echo conf file $conf created
fi

function readit {		#this is the read through list function
	echo $USER\'s list:
	i=1
	while read l; do
		echo $i - $l
		((i++))
	done <$conf
	if [[ "$i" = 1 ]]; then
		echo '- its empty!'
	fi
}

function help {		#this is the help message
	echo this is the 'bashlist' script help message
	echo this script maintains a list of things for you
	echo
	echo using -h or --help will display this message
	echo using -l or --list will read to you the list without clearing the screen
	echo using -f or --fpop will remove the first item from the list
	echo using -b or --bpop will remove the last item from the list
	echo using -r or --remove and a number will remove that number item from the list
	echo using -r or --remove alone works the same as -f or --fpop
	echo using -e or --empty will clear the entire list
	echo using no argument works the same as -l and --list, except it clears the screen
	echo any other argument is read as input and added to the bottom of the list
	echo
	echo the list is kept in $conf
	echo
}

if [ "$#" -gt 2 ]; then
	clear
    echo too many parameters
    help
    exit
elif [ "$1" = -r ] || [ "$1" = --remove ]; then		#catch for remove option
	clear
	if [[ -s $conf ]] ; then		#checking for an empty list
		if [ "$#" -gt 1 ]; then
			numlines=$(cat $conf | wc -l)
			if [ "$2" -gt "$numlines" ]; then
				echo that number entry does not exist
			else
				echo removing entry number $2
				sed -i '' "$2"d $conf		#mac osx way to use sed
			fi
		else
			line=$(head -n 1 $conf)
			echo removing first entry, $line
			sed -i '' '1d' $conf		#mac osx way to use sed
		fi
		readit
	else
		echo list is empty
	fi
	exit
elif [ "$#" -gt 1 ]; then
	clear
    echo too many parameters
    help
    exit
elif [ -z "$1" ]; then
	clear
	readit
	exit
else
	if [ "$1" = -h ] || [ "$1" = --help ]; then		#catch for help option
		clear
		readit
		help
	elif [ "$1" = -l ] || [ "$1" = --list ]; then		#catch for list option
		readit
	elif [ "$1" = -f ] || [ "$1" = --fpop ]; then		#catch for fpop option
		clear
		if [[ -s $conf ]] ; then		#checking for an empty list
			line=$(head -n 1 $conf)
			echo removing first entry, $line
			sed -i '' '1d' $conf		#mac osx way to use sed
			readit
		else
			echo list is empty
		fi;
	elif [ "$1" = -b ] || [ "$1" = --bpop ]; then		#catch for bpop option
		clear
		if [[ -s $conf ]] ; then		#checking for an empty list
			line=$(tail -1 $conf | head -1)
			echo removing last entry, $line
			sed -i '' '$d' $conf		#mac osx way to use sed
			readit
		else
			echo config list is empty
		fi;
	elif [ "$1" = -e ] || [ "$1" = --empty ]; then		#catch for bpop option
		clear
		echo clearing the whole list
		> $conf
		readit
	else
		clear
		echo "$1" >> $conf		#adding argument to list
		echo "$1" added to the list
		readit
	fi
	exit
fi