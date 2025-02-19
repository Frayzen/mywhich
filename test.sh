#!/bin/sh

cur=`pwd`
dir=`mktemp -d /tmp/mytest.XXXXXX`
trap "rm -rf $dir" EXIT INT HUP QUIT
fulldir=$dir/1
for cmd in /usr/bin/which $cur/which.sh
do
  mkdir "$fulldir"
  cd $fulldir
  $cmd $@ >stdout 2>stderr
  echo $? >rc
  fulldir=$dir/2
done
echo ok
diff -r $dir/2 $dir/1

