#!/usr/bin/env bash

sh etc/banner.sh > /tmp/heads$$

one() {
  echo "# $1 ..."
  cat $1 | gawk '
    BEGIN { RS = "^$"
            f  = "'/tmp/heads$$'"
            getline top < f
            close(f)
            FS="\n"
            RS="" }
    NR==1 { print top 
            if($0 ~ /class=sehero/) next  }
    1     { print ""; print $0 }
    ' > /tmp/$$new
  cp /tmp/$$new $1
}

while read x ; do
  one $x
done
