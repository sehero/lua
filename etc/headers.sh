#!/usr/bin/env bash

b="https://img.shields.io/badge"
u='https://github.com/sehero/lua'
r="$u/blob/master"
i='https://c0.wallpaperflare.com/preview/66/740/843/programmer-computer-woman-support.jpg'
i='https://images.vexels.com/media/users/3/152694/isolated/preview/5e0cb3e5b59081464d73f94075301dbb-woman-sitting-at-desk-silhouette-by-vexels.png'
i='https://i1.wp.com/s3.amazonaws.com/production-wordpress-assets/blog/wp-content/uploads/2013/03/manual_override-1.png?resize=282%2C479&ssl=1'
i='https://imgs.xkcd.com/comics/superm_n_2x.png'
i="https://www.artistshot.com/assets-3/images/admin/designs/205850/205850-250x250.png"
i='https://cdn.shopify.com/s/files/1/0010/1942/products/2313703_1024x1024@2x.png?v=1547576275'
i='doc/etc/img/spiderman.png'
i='https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/2c218305-10f7-4dc5-b98c-8944ea7c6b98/d97u6ii-1458232e-599d-46ed-9eff-579c88752d54.jpg/v1/fill/w_521,h_800,q_75,strp/spidey_and_gwen_color_by_dekarogue_d97u6ii-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3siaGVpZ2h0IjoiPD04MDAiLCJwYXRoIjoiXC9mXC8yYzIxODMwNS0xMGY3LTRkYzUtYjk4Yy04OTQ0ZWE3YzZiOThcL2Q5N3U2aWktMTQ1ODIzMmUtNTk5ZC00NmVkLTllZmYtNTc5Yzg4NzUyZDU0LmpwZyIsIndpZHRoIjoiPD01MjEifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.T6i4XX_UokR1xTTjz5JL2pARbfbEFa3WS_pjq5px7Kw'

cat <<EOF> /tmp/heads$$
<a class=sehero name=top> 
<img align=right width=300 src="$i">
<h1><a href="$f/README.md#top">SE for super heroes: an AI approach</a></h1> 
<p> <a
href="$r/LICENSE">license</a> :: <a
href="$r/INSTALL.md#top">install</a> :: <a
href="$r/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="$u/issues">issues</a> :: <a
href="$r/CITATION.md#top">cite</a> :: <a
href="$r/CONTACT.md#top">contact</a> </p><p> 
<img src="$b/license-mit-red">   
<img src="$b/language-lua-orange">    
<img src="$b/purpose-ai,se-blueviolet"><br>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a><br>
<img src="$b/platform-mac,*nux-informational"><br>
<a href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/sehero/lua.svg?branch=master"></a><br>  
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
