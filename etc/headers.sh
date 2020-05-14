#!/usr/bin/env bash

b="https://img.shields.io/badge"
u='https://github.com/sehero/lua'
r="$u/blob/master"
i='https://c0.wallpaperflare.com/preview/66/740/843/programmer-computer-woman-support.jpg'
i='https://images.vexels.com/media/users/3/152694/isolated/preview/5e0cb3e5b59081464d73f94075301dbb-woman-sitting-at-desk-silhouette-by-vexels.png'
i='https://i1.wp.com/s3.amazonaws.com/production-wordpress-assets/blog/wp-content/uploads/2013/03/manual_override-1.png?resize=282%2C479&ssl=1'
i='https://imgs.xkcd.com/comics/superm_n_2x.png'
i='doc/etc/img/spiderman.png'

cat <<EOF> /tmp/heads$$
<a class=sehero name=top> 
<h1><a href="$f/README.md#top">SE for super heroes: an AI approach</a></h1> <p> <a
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
<img align=right width=300 src="$i">
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
