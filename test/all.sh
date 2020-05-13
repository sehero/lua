#!/usr/bin/env bash

Files="
libok
csvok
numok
symok
dataok
"

for f in $Files; do 
  (cd ../src; lua $f.lua)
done
