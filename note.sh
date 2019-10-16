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

## CASE 5
# > note [Folder name] [Note name]
#	Create a note with the above name in the above folder. 
# 	If the folder does not exist, raise an error.
#	If no folder name is supplied, a 'default' folder is created / used

######

notes_folder=~/Documents/.notes/
default_notes=~/Documents/.notes/default/

mkdir -pv "$notes_folder"
mkdir -pv "$default_notes"

#####

if [ "$#" -eq "0" ]
then
	echo "Sourcing default folders"
	exit 0
fi

#####

r_flag=false
f_flag=false

print_conflicting() {
	printf "Conflicting flags, -r used for removal, -f for creation \n"
}

print_usage() {
  printf "Usage: note [-r | -f] [folder] [notename] \n\t-r | Remove a folder or file\n\t-f | Create folder\n"
}

while getopts 'rf' flag; do
  case "${flag}" in
    r) r_flag=true ;;
    f) f_flag=true ;;
    \?) print_usage
       exit 1 ;;
  esac
done

if [ r_flag = true ]
then
	echo "R flag set"
fi
if [ f_flag = true ]
then
	echo "F flag set"
fi


if [ r_flag = true -a f_flag = true ] 
then
	echo "This is the error place\n"
	
	print_conflicting ;
	print_usage ;
	exit 1 ;
fi

# At this point, either r, or f, or neither is true. Checking each one can isolate each case.

if [ f_flag ]
then
	# create a folder in some capacity

	if [ "$#" -eq "2" ]
	then
		# CASE 1
		
		# find out if the user put the flag in the right place:
		if [ "$1" = "-f" ]
		then
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

	if [ "$#" -eq "3" ]
	then
		# CASE 2
		
		# find out if the user put the flag in the right place:
		if [ "$1" = "-f" ]
		then
			# first argument if -f
			# make directory on second arg
			cd "$notes_folder"
			mkdir -pv "$2"
			# create file in that directory
			cd "$2"
			touch "$3" 
			# open said file in Sublime
			open -a "Sublime Text" "$3"
		fi
		exit 0;
	fi
	print_usage ;
	exit 1 ;
fi

if [ r_flag ]
then
	# remove file or folder

	if [ "$#" -eq "2" ]
	then
		# CASE 3
		
		exit 0;
	fi

	if [ "$#" -eq "3" ]
	then
		# CASE 4

		exit 0;
	fi

	print_usage ;
	exit 1 ;
fi

# create a note ( no flags passed )
# CASE 5

if [ "$#" -eq "2" ]
then
	# Create a file
	
	

	exit 0;
fi

print_usage ;
exit 1 ;

