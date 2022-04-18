#!/usr/bin/env gawk -f
# vim: filetype=awk ts=2 sw=2 sts=2 et :

BEGIN { main() }

function main(     tmp,the) {
  args(tmp,"gawk -f fred.awk [OPTIONS]    ",
           "(c) 2022 Tim Menzies        \n",
           "OPTIONS:                      ",
           "  --seed  random number seed 10019",
           "  --bins  number bins     10",
           "  --help  show help text  0 ",
           "  --copy  show copyright  0 ")        
  help(tmp,the) }

#------------------------------------------------------------------------------
function help(a,the,     bj,flag,words) {
  for(j in a) {
    if (a[j] ~ /[ \t]*--/) {
     split(a[j],words," ")
     the[gnsub("--(.*)","\\1",words[1])] = coerce(cli(words[1],last(words)))}}
  if (the["help"]) print cat(a,"\n") }

function gnsub(from,to,src) { return gensub(from,to,"g",src) }

function cli(flag, b4) {
  for(j in ARGV) 
    if (ARGV[j]==flag) 
      return b4==0 ? 1 : (b4==1 ? 0 : ARGV[j+1])
  return b4 }

function list(a)     { split("",a,"") }
function last(a)     { return a[length(a)] } 
function push(a,x)   { a[1+length(a)] = x; return x }
function coerce(x,y) { y=x+0; return  x==y ? y : x }
function cat(a,sep0,    j,s,sep)  {
  ooSortOrder(a)
  for(j in a) {s=s sep a[j]; sep=sep0}
  return s }

function oo(x,p,pre,     j,txt) {
  txt = pre ? pre : (p DOT)
  ooSortOrder(x)
  for(j in x)  
    if (isarray(x[i])) { print(txt j"" ); oo(x[j],"","|  " pre)   }
    else               { print(txt j (x[j]=="" ? "" : ": " x[j])) }}

function ooSortOrder(x, i) {
  for (i in x)
    return PROCINFO["sorted_in"] = \
      typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"}

function rogues(    s) {
  for(s in SYMTAB) if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) if (s ~ /^[_a-z]/    ) print "#W> Rogue: " s>"/dev/stderr"}

function tests(what, all,   one,a,i,n) {
  n = split(all,a,",")
  print "\n#--- " what " -----------------------"
  for(i=1;i<=n;i++) { one = a[i]; @one(one) }
  rogues() }

function arg(z,x) { if (x!="") push(z,x) }
function args(z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,
                a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,l1,m1,
                n1,o1,p1,q1,r1,s1,t1,u1,v1,w1,x1,y1) {
   list(z)
   arg(z,a);  arg(z,b);  arg(z,c);  arg(z,d);  arg(z,e);  arg(z,f);  arg(z,g) 
   arg(z,h);  arg(z,i);  arg(z,j);  arg(z,k);  arg(z,l);  arg(z,m);  arg(z,n) 
   arg(z,o);  arg(z,p);  arg(z,q);  arg(z,r);  arg(z,s);  arg(z,t);  arg(z,u) 
   arg(z,v);  arg(z,x);  arg(z,y);  arg(z,a1); arg(z,b1); arg(z,c1); arg(z,d1) 
   arg(z,e1); arg(z,f1); arg(z,g1); arg(z,h1); arg(z,i1); arg(z,j1); arg(z,k1) 
   arg(z,l1); arg(z,m1); arg(z,n1); arg(z,o1); arg(z,p1); arg(z,q1); arg(z,r1) 
   arg(z,s1); arg(z,t1); arg(z,u1); arg(z,v1); arg(z,x1); arg(z,y1) } 
