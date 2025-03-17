#!/bin/sh

# Enable failure on error returned  
set -e

allmatch=false # Option '-a' see man

while getopts ":a" curopt # Parses the arguments
do
  case $curopt in
    a) allmatch=true # option '-a' present
       ;;
    ?) # Error on invalid argument
      echo "which: unknown option -- ${OPTARG}" 1>&2
      echo "usage: which [-a] name ..." 1>&2
      exit 1
      ;;
  esac
done
shift $(($OPTIND - 1)) # Get rid of parsed arguments 

if [ $# -eq 0 ]; then # Check for absence of argument
  echo "usage: which [-a] name ..." 1>&2
  exit 1
fi

all=true # Flag set when all arguments have a match
some=false # Flag set when any argument has a match 
for arg in "$@"; do # Loop on the arguments
  found=false # Flag set if the current argument has a match
  oldIFS="$IFS" # Save the IFS
  IFS=":" # Split the PATH variable by semicolomn
  for path in $PATH; do
    file="$path/$arg"
    if [ -x $file -a -f $file ]; then # If the path is a file and has execute access
      echo $file
      found=true # Set the flag
      if ! $allmatch; then # If the '-a' option is not set
        break # Stop after a single matching path 
      fi
    fi
  done
  if ! $found; then # If current has not been found in $PATH
    echo "which: $arg: Command not found." 1>&2
    all=false
  else # Otherwise
    some=true
  fi
  IFS="$oldIFS" # Restore IFS
done

if $all; then # All files found
  exit 0
elif $some; then # Some file found
  exit 1
else # No file found
  exit 2
fi
