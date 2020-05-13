#!/usr/bin/env bash

b="https://img.shields.io/badge"
u='https://github.com/sehero/lua'
r="$u/blob/master"

cat <<EOF> /tmp/heads$$
<p align=center><b>SE for super heroes: an AI approach
</b><br><a
href="$r/README.md">about</a> :: <a
href="$u">code</a> :: <a
href="$r/LICENSE">license</a> :: <a
href="$r/INSTALL.md">install</a> :: <a
href="$r/CODE_OF_CONDUCT.md">contribute</a> :: <a
href="$u/issues">issues</a> :: <a
href="$r/CITATION.md">cite</a> :: <a
href="$r/CONTACT.md">contact</a> <p
align=center> <img
src="$b/language-lua-orange"> <img
src="$b/purpose-ai,se-blueviolet"> <img
src="$b/platform-mac,*nux-informational"> <img
src="$b/license-mit-red"> <img
src="https://travis-ci.org/sehero/src.svg?branch=master"> <a 
href="https://zenodo.org/badge/latestdoi/263210595"><img 
src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a>
</p><hr>
EOF

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
            if($0 ~ /<p align=center/) next  }
    1     { print ""; print $0 }
    ' > /tmp/$$new
  cp /tmp/$$new $1
}

while read x ; do
	one $x
done
