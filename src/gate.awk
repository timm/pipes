#!/usr/bin/env gawk -f  
# vim: filetype=awk ts=2 sw=2 sts=2 et :

## gawk -f gate.awk [OPTIONS]
## (c) 2022, Tim Menzies, BSD 2-clause license
##
## OPTIONS:
##  --lnorm  co-effecient on   2
##  --about   show help         0
##  --file   file ../data/auto93.csv
 
BEGIN { main() }

function cli(o,     i,k) {
  read("gate.awk"," ","cli1",o)
  for(i in ARGV) {
    k = ARGV[i]
    if (gsub(/^--/,"",k) && k && (k in o))  
      o[k] = o[k]==1 ? 0 : (o[k]==0 ? 1 : coerce(ARGV[i+1]))} }
      
function main(    o) {
  cli(o)
  if (o["help"]) help()
  rows(o)
  asort(Data, Data, "betters")
  for(i=1; i<=length(Data); i++) Data[i]["rank"] = i 
  oo(Data) }
 
function read(f,sep,fun,payload,   old,n) {
  old=FS; FS=sep  
  while((getline < f) > 0) @fun(++n,payload);
  FS=old; close(f) }

function rows(o)   { read(o["file"],",","row1") }
function row1(n,_) { for(i=1; i<=NF;i++)  n==1 ? header(i,$i) : datum(i,$i,n-1)}

function help()      { read("gate.awk"," ","help1") }
function help1(_,__) { if (gensub(/##/,"",$1)) { print $0 } } 

function cli1(_,o) { if (gsub(/^--/,"",$2)) o[$2] = coerce($NF) }

#---------------------------------------------------------------------------   
function header(i,x) {
  Names[i]=x
  if (x ~ /^[A-Z]*/) {  Lo[i] = 1E32; Hi[i] = -1E32 }
  if (x ~ /-$/) W[i] = -1
  if (x ~ /+$/) W[i] =  1 }

function datum(i,x,n) {
  if (x != "?" &&  (i in Lo)) {
    x = coerce(x)
    Lo[i] = x < Lo[i] ? x : Lo[i]
    Hi[i] = x > Hi[i] ? x : Hi[i] }
  Data[n]["raw"   ][i] = x 
  Data[n]["cooked"][i] = x }

#---------------------------------------------------------------------------   
function betters(i1,x,i2,y) { return better(x["raw"], y["raw"]) ? -1 : 1 }

function better(r1,r2,    n,s1,s2,a,b) {
  n=length(W); s1=s2=0
  for(c in W) {
    a   = norm(c, r1[c])
    b   = norm(c, r2[c])
    s1 -= 2.7183^(W[c]*(a-b)/n)
    s2 -= 2.7183^(W[c]*(b-a)/n) }
  return s1/n < s2/n }

#---------------------------------------------------------------------------   
function first(a,   i) { for(i in x) return a[i] }
function abs(x)        { return x<0 ? -1*x : x      }
function coerce(x,y)   { y=x+0; return x==y ? y : x }

function norm(c,x,     lo,hi,tmp) {
  lo=Lo[c]; hi=Hi[c]
  return x=="?" ? x : (abs(lo-hi) < 1E-9 ? 0 : (x-lo)/(hi-lo+1E-32)) }

function oo(x,p,pre, i,txt) {
  txt = pre ? pre : (p ".")
  sortOrder(x)
  for(i in x) { if (isarray(x[i]))   { 
                  print(txt i"" ); oo(x[i],"","|  " pre)
              } else print(txt i (x[i]==""?"": ": " x[i])) }}

function sortOrder(x) { PROCINFO["sorted_in"] = \
                typeof(first(x)+0)=="number" ? "@ind_num_asc" : "@ind_str_asc" }

function rogues(    s) {
  for(s in SYMTAB) if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) if (s ~ /^[_a-z]/    ) print "#W> Rogue: " s>"/dev/stderr"}
