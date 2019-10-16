# note 

# Usage

## CASE 1
# > note -f [Folder name]
#	Create a folder with the above name, and use as a reference

## CASE 2
# > note -f [Folder name] [Note name]
#	Create a note with the above name in the above folder. 
# 	If the folder does not exist, create it.

## CASE 3
# > note -r [Folder name]
#	Remove the specified folder

## CASE 4
#> note -r [Folder name] [Note name]
#	Remove the specified note

## Default
# > note [Folder name] [Note name]
#	Create a note with the above name in the above folder. 
# 	If the folder does not exist, raise an error.
#	If no folder name is supplied, a 'default' folder is created / used

cd ~

######

notes_folder=~/Documents/.notes/
default_notes=~/Documents/.notes/default/

mkdir -pv "$notes_folder"
mkdir -pv "$default_notes"

#####

if [ "$#" -eq "0" ]; then
	echo "Sourcing default folders"
	exit 0
fi

#####

r_flag=false
f_flag=false
o_flag=false

print_conflicting() {
	printf "Conflicting flags, -r used for removal, -f for creation \n"
}

print_usage() {
	printf "Usage: note [-r | -f] [folder] [notename] \n\t-r | Remove a folder or file\n\t-f | Create folder\n"
}

while getopts 'rfo' flag; do
	case "${flag}" in
		r) r_flag=true ;;
		f) f_flag=true ;;
		o) o_flag=true ;;
		\?) print_usage
		    exit 1 ;;
	esac
done

## only one flag allowed
declare -i count
count=0
if [ "$r_flag" = "true" ]; then
	count=count+1
fi
if [ "$f_flag" = "true" ]; then
	count=count+1
fi
if [ "$o_flag" = "true" ]; then
	count=count+1
fi

if [ "$count" -gt "1" ] 
then	
	print_conflicting ;
	print_usage ;
	exit 1 ;
fi

# At this point, either r, f or o, or none are true. Checking each one can isolate each case.

if [ "$f_flag" = "true" ]; then
	# create a folder in some capacity
	if [ "$#" -eq "2" ]; then
		# CASE 1
		
		# find out if the user put the flag in the right place:
		if [ "$1" = "-f" ]; then
			# first argument is -f
			# make directory on second arg
			cd "$notes_folder"
			mkdir -pv "$2"
			cd ~
		else
			print_usage
			exit 1
		fi

		exit 0;
	fi

	if [ "$#" -eq "3" ]; then
		# CASE 2

		# find out if the user put the flag in the right place:
		if [ "$1" = "-f" ]; then
			# first argument if -f
			# make directory on second arg
			cd "$notes_folder"
			mkdir -pv "$2"
			# create file in that directory
			cd "$2"
			touch "$3" 
			# open said file in Sublime
			open -a "Sublime Text" "$3"
		else
			print_usage
			exit 1
		fi
		exit 0;
	fi
	print_usage ;
	exit 1 ;
fi

if [ "$r_flag" = "true" ]; then
	# remove file or folder

	if [ "$#" -eq "2" ]; then
		# CASE 3

                # find out if the user put the flag in the right place:
                if [ "$1" = "-r" ]; then
                        # first argument is -r
                        # remove directory on second arg
                        cd "$notes_folder"
			                        
			num_notes=$(ls -1 | wc -l)
			num_notes_nw="$(echo "${num_notes}" | tr -d '[:space:]')"

			read -r -p "Are you sure you want to delete $2 and all $num_notes_nw notes? [y/N] " response
			case "$response" in
				[yY][eE][sS]|[yY])	rm -rf $2 ;;
    				*)  			exit 0 ;;
			esac

                        cd ~
                else
			print_usage
                        exit 1
                fi

		exit 0;
	fi

	if [ "$#" -eq "3" ]
	then
		# CASE 4

                # find out if the user put the flag in the right place:
                if [ "$1" = "-r" ]
                then
                        # first argument is -r
                        # remove file on third arg within directory on second arg
                        cd "$notes_folder"
			cd "$2"
			                        
			read -r -p "Are you sure you want to delete $3? [y/N] " response
			case "$response" in
				[yY][eE][sS]|[yY])	rm $3 ;;
    				*)  			exit 0 ;;
			esac

                        cd ~
                else
			print_usage
                        exit 1
                fi
		exit 0;
	fi
	print_usage ;
	exit 1 ;
fi

if [ "$o_flag" = "true" ]; then
	# open, without creating new
	if [ "$#" -eq "2" ]; then
		# make sure flag is $1
		if [ "$1" = "-o" ]; then
			# > note -o [filename]
			# try openning, if it exists
			cd "$default_notes"
					
			if [ -e "$2" ]; then
				open -a "Sublime Text" "$2"
			else
				echo "Note does not exist"
			fi

			cd ~
			exit 0
		else
			print_usage
			exit 1
		fi
	fi
	
	if [ "$#" -eq "3" ]; then
		# make sure flag is $1
		if [ "$1" = "-o" ]; then
			# > note -o [folder] [filename]
			# try openning, if it exists
			cd "$notes_folder"
			
			if [ -d "$2" ]; then
				cd "$2"
				if [ -e "$3" ]; then
					open -a "Sublime Text" "$3"
				else
					echo "Note does not exist"
				fi
			else
				echo "Folder $3 doesn't exist"
				exit 1
			fi
			cd ~
			exit 0
		else
			print_usage
			exit 1
		fi
	fi
	
	print_usage
	exit 1
fi

# create a note ( no flags passed )
# Default

if [ "$#" -eq "2" ]
then
	# Create a file
	cd "$notes_folder"
	
	if [ -e "$1" ]; then
		cd "$1"
		touch "$2"
		open -a "Sublime Text" "$2"
		cd ~
	else
		echo "Folder does not exist"
		print_usage
		exit 1
	fi

	exit 0
fi
if [ "$#" -eq "1" ]; then
	# create a file in default
        cd "$default_notes"
        # create file in that directory
        touch "$1"
        # open said file in Sublime
        open -a "Sublime Text" "$1"

	exit 0
fi

print_usage
exit 1

