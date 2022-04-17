# vim: filetype=awk ts=2 sw=2 sts=2 et :

@include "lib"

function copy(a,b,  j) { for(j=1;j<=length(a);j++) b[j]=a[i] }

function lines(i,s) {
  Object(i); i["is"]="Lines"
  i["string"] = s
  at(i,"lines")
  split(/\n/,a,s)
  copy(a,i["lines"])
  i["n"]=0 }

function line(i,    x) {
  i["n"]++
  if (i["n"]) <= length(i["lines"])) return i["lines"][i["n"]] }
