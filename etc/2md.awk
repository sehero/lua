function run(top,  # is this top of file?
             b4,   # was the last line a comment?
             loop, # are we looping over multi-line comments?
             code) # are we running thru a code block?
{
  if (getline <= 0) exit  # end of file
  if (/^[ \t]*$/) { 
    if (!code) # skip blank lines inside code blocks
      print 
    return run(top,b4,loop,code) 
  }
  if (sub(/^--\]\]/,""))  # end looping over multi-line comments
    return run(0,1,0,1) 
  if (sub(/^--\[\[/,"")) {# loop over multi-line comments
    if (!top)             # if top, then nothing before to be close
      print "```" 
    return run(0,b4,1,0) 
  }
  if (loop) { # loop over multi line commnts
    print
    return run(0,b4,loop,0) 
  }
  # handle the transistion between comments and non-comments
  now = sub(/^-- /,"")
  if ( b4 && !now) { code=1; print "```lua" }
  if (!b4 &&  now) { code=0; print "```"    }
  print 
  run(0,now,0,code)
}

BEGIN { run(1,0,0,0) }
