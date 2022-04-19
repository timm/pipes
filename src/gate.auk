#!/usr/bin/env gawk -f
# vim: filetype=awk ts=2 sw=2 sts=2 et :

BEGIN { FS=OFS=","; 
        O["p"]    = 2
        O["file"] = "-"
        main(o) }

function cli(o,     j) {
  for(j in ARGV) 
    if (gsub(/^--/,"",ARGV[j]) && (ARGV[i] in o)) 
      o[ARGV[i]] = flip(o[ARGV[i]], ARGV[j+1]) }

function main(o,  i) {
  load(O["file"])
  asort(Data, Data, "betters")
  for(i=1;i<=length(Data);i++) Data[i]["rank"] = i }
 
function load(f,   i) {
  while((getline<f) > 0) 
    for(i=1; i<=NF;i++)  
      ++n ? data(i,$i) : header(i,$i)   }

#### ---------------------------------------------------------------------------   
function header(i,x) {
  Names[i]=x
  if (x ~ /^[A-Z]*/) {  Lo[i] = 1E32; Hi[i] = -1E32 }
  if (x ~ /-$/) W[i] = -1
  if (x ~ /+$/) W[i] =  1 }

function datum(i,x) {
  if (x != "?" &&  (i in Lo))   {
    x = coerce(x)
    Lo[i] = x<Lo[i] ? x : Lo[i]
    Hi[i] = x>Hi[i] ? x : Hi[i] }
  Data[NR-1]["raw"   ][i] = x 
  Data[NR-1]["cooked"][i] = x }

#### ---------------------------------------------------------------------------   
function betters(i1,x,i2,y) { return better(x["raw"], y["raw"]) ? -1 : 1 }

function better(r1,r2,    ,n,s1,s2,a,b) {
  n=length(W); s1=s2=0
  for(c in W) {
    a   = norm(c, r1[c])
    b   = norm(c, r2[c])
    s1 -= 2.7183^(W[c]*(a-b)/n)
    s2 -= 2.7183^(W[c]*(b-a)/n) }
  return s1/n < s2/n }

#### ---------------------------------------------------------------------------   
function abs(x)        { return x<0 ? -1*x : x      }
function coerce(x,y)   { y=x+0; return x==y ? y : x }
function flip(old,new) { return old==0 ? 1 : (old==1 ? 0 : coerce(new)) }

function norm(c,x,     lo,hi,tmp) {
  lo=Lo[c]; hi=Hi[c]
  return x=="?" ? x : (abs(lo-hi) < 1E-9 ? 0 : (x-lo)/(hi-lo+1E-32)) }

function oo(x,p,pre, i,txt) {
  txt = pre ? pre : (p DOT)
  sortOrder(x)
  for(i in x) { if (isarray(x[i]))   { 
                  print(txt i"" ); oo(x[i],"","|  " pre)
              } else print(txt i (x[i]==""?"": ": " x[i])) }}

function sortOrder(x, i) {
  for (i in x)
    return PROCINFO["sorted_in"] =\
      typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc" }

function rogues(    s) {
  for(s in SYMTAB) if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) if (s ~ /^[_a-z]/    ) print "#W> Rogue: " s>"/dev/stderr"}
