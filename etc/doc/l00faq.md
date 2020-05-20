<a class=sehero name=top><img align=right width=280 src="docs/assets/img/spiderman.png">
<h1><a href="/README.md#top">SE for super heroes: an AI approach</a></h1> 
<p> <a
href="https://github.com/sehero/lua/blob/master/LICENSE">license</a> :: <a
href="https://github.com/sehero/lua/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/sehero/lua/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/sehero/lua/issues">issues</a> :: <a
href="https://github.com/sehero/lua/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/sehero/lua/blob/master/CONTACT.md#top">contact</a> </p><p> 
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-lua-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet"><br>
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/sehero/lua"><img 
src="https://travis-ci.org/sehero/lua.svg?branch=master"></a>
<a href="https://zenodo.org/badge/latestdoi/263210595"><img src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a>
<a href='https://coveralls.io/github/sehero/lua?branch=master'><img src='https://coveralls.io/repos/github/sehero/lua/badge.svg?branch=master' alt='Coverage Status' /></a></p>



## What about all the pthe AI tools not mentioned here?

This is one way, not the way.

No single text can list them all.

Happily, across all these tools there are common themes, e.g.
landscape analysis (the study of the shape of the data and
how we can move around it). 

## Why Lua?

## Where's the deep learning?

## Rows

<img width=400 src="http://github.com/sehero/lua/blob/master/doc/etc/img/spaces.png">

Rows contain `cells` and cells 
contain multiple `x` and `y` value.  When there is only one `y`
value, then that can be used for:

- classification, if the column is a `Sym`bol;
- regression, if the column is a `Num`ber.

When there is more than one `Num`eric `y` value, then this becomes
a multi-objective optimization problem.

Much of the processing has the following pattern:

- Grab some columns _col1,col2,..._;
- Using _colx.pos_, take a value from `aRow.cells[x]`.
- Then using the services defined in `colx`, take some action on that value.

## polymorphs

- `aCol:add(x)`:  update a summary with `x`. e.g. if adding a number to a `Num`, update
  the `lo` and `hi` values seen in that summary.
- `aCol:sub(x)`: take `x` from the summary (only defined for some kind of `Col`s). 
- `aCol:norm(x)`: convert numbers to `0..1` according to  the known `lo` and `hi` values
  known for that summary.
- `aCol:mid()`: return the central value of this distribution; e.g. for `Num`, return
  the mean value `mu`.
- `aCol:var()`: return how much the summary varies around the `mid`; e.g. report `Num`'s
  standard deviation.
- `aCol:__tostring()`: offer a short description of `aCol`.
- `aCol:strange(x)`: report if `x` is probably not part of this summary
- `dist` : this is a recursive polymorphic  message. 
