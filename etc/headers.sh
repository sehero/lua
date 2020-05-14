#!/usr/bin/env bash

b="https://img.shields.io/badge"
u='https://github.com/sehero/lua'
r="$u/blob/master"

cat <<EOF> /tmp/heads$$
<a class=sehero name=top> <h1> SE for super heroes: an AI approach
</h1> <img align=right width=300
src="https://cdn.pixabay.com/photo/2019/08/01/21/40/spiderman-4378357_1280.png"> <p> <a
href="$r/README.md">home</a> :: <a
href="$u">code</a> :: <a
href="$r/LICENSE">license</a> :: <a
href="$r/INSTALL.md#top">install</a> :: <a
href="$r/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="$u/issues">issues</a> :: <a
href="$r/CITATION.md#top">cite</a> :: <a
href="$r/CONTACT.md#top">contact</a> </p><p> 
<img src="$b/license-mit-red">   
<img src="$b/language-lua-orange">    
<img src="$b/purpose-ai,se-blueviolet">  
<img src="$b/platform-mac,*nux-informational"><br>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a><br>
<img src="https://travis-ci.org/sehero/src.svg?branch=master"><br>  
</p>
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
            if($0 ~ /class=sehero/) next  }
    1     { print ""; print $0 }
    ' > /tmp/$$new
  cp /tmp/$$new $1
}

while read x ; do
	one $x
done
