# vi: filetype=awk ts=2 sw=2 sts=2 et :
@include "lib"
#namespace "Obj"

function new(i)  { 
  split("",i,"")
  i["is"]= "Obj"
  i["id"] = ++ID }


