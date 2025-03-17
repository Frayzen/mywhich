 #!/bin/sh

set -e

first=true
allmatch=false

while getopts ":a" curopt
do
  case $curopt in
    a) allmatch=true
       ;;
    ?) 
      echo "which: unknown option -- ${OPTARG}" 1>&2
      echo "usage: which [-a] name ..." 1>&2
      exit 1
      ;;
  esac
done
shift $(($OPTIND - 1))

if [ $# -eq 0 ]; then
  echo "usage: which [-a] name ..." 1>&2
  exit 1
fi

all=true
some=false
for arg in "$@"; do
  found=false
  oldIFS="$IFS"
  IFS=":" 
  for path in $PATH; do
    file="$path/$arg"
    if [ -x $file ]; then
      echo $file
      found=true
      if ! $allmatch; then
        break
      fi
    fi
  done
  if ! $found; then
    echo "which: $arg: Command not found." 1>&2
    all=false
  fi
  if $found; then
    some=true
  fi
  IFS="$oldIFS"
done

if $all; then
  exit 0
elif $some; then
  exit 1
else #none
  exit 2
fi
