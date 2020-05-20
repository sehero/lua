

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
