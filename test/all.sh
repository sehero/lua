#!/usr/bin/env bash

cd ../src

for i in  *ok.lua; do
  echo $i
  s="$s print('\n'..string.rep(\"-\",70)); print('-- $i','\n'); dofile('$i'); "
done 

echo $s

lua="../lua-5.3.5/src/lua" # true if we are running on travis

if [ ! -f "$lua" ] # true if we are NOT running on travis
then lua="lua"
fi

$lua -e "$s" | 
gawk ' 
1                                # a) print current line      
/^Failure/       { err += 1 }    # b) catch current error number
END              { exit err - 1} # c) one test is designed to fail 
                                 #    (just to test the test engine)
                                 #    so "pass" really means, "only
                                 #    one test fails"
'

out="$?"

echo "Number of problems: $out"

exit $out
