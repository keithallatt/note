# note 

# Different ways of using note

# > note -f [Folder name]
#	Create a folder with the above name, and use as a reference

# > note (-f) [Folder name] [Note name]
#	Create a note with the above name in the above folder. 
# 	If the folder does not exist, and -f is not flagged, return 
#	an error, if -f is flagged, create the folder.

# > note -r [Folder name]
#	Remove the specified folder

#> note -r [Folder name] [Note name]
#	Remove the specified note


r_flag='false'
f_flag='false'

print_usage() {
  printf "Usage: note [-r] [-f] [folder] [notename] \n"
}

while getopts 'rf' flag; do
  case "${flag}" in
    r) r_flag='true' ;;
    f) f_flag='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done




