# vi: filetype=awk ts=2 sw=2 sts=2 et :
@include "lib"
@namespace "obj"
@namespace "num"

function new(i,at,name)
  obk::new(i,at,name)
  i.at = at or 0 }
