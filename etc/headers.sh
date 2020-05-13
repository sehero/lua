#!/usr/bin/env bash
q='"'
u='https://github.com/ai-se/perfect-repo'
r="$u/blob/master"

cat<<EOF> /tmp/heads$$
<p align=center><b>A perfect repo
</b><br><a 
href="$r/README.md">about</a>  :: <a 
href="$u">code</a>  :: <a 
href="$r/LICENSE">license</a>  :: <a 
href="$r/INSTALL.md">install</a> :: <a
href="$r/CODE_OF_CONDUCT.md">contribute</a> :: <a 
href="$u/issues">issues</a> ::  <a 
href="$r/CONTACT.md">contact</a> <p 
align=center> <img 
src="https://img.shields.io/badge/language-python-orange">&nbsp;<img 
src="https://img.shields.io/badge/purpose-ai,se-blueviolet">&nbsp;<img 
src="https://img.shields.io/badge/platform-mac,*nux-informational">&nbsp;<img 
src="https://img.shields.io/badge/license-mit-informational">&nbsp;<img 
src="https://travis-ci.com/ai-se/perfect-repo.svg?branch=master"> 
</p><hr>
EOF

#if [ $0 -nt $1 ]; then
  echo "# $1 ..."
  cat $1 |
  gawk 'BEGIN  {
    RS = "^$"
    f  = "'/tmp/heads$$'"
    getline top < f
    close(f)
    FS="\n"
    RS=""
  }
  NR==1 { print top 
          if($0 ~ /<p align=center/) next  }
  1     { print ""; print $0}
  ' > /tmp/$$new

  cp /tmp/$$new $1

#fi
