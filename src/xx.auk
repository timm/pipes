# vim: filetype=awk ts=2 sw=2 sts=2 et :
@include "lib"

@namespace "xx"

HELP="gawk -f fred.awk [OPTIONS]      \n"\
     "(c) 2022 Tim Menzies          \n\n"\
     "OPTIONS:                        \n"\
     "  --help -h show help text  0   \n"\
     "  --copy -C show copyright  0   \n"\        

function coerce(x, y) { y=x+0; return x==y ? y : x }

function line(str,fun,     j,k,n,lines,words) {
 n= split(/\n/,lines,str)
 for(j=1; j<=n; j++) {
   split(/[ \t]+/, words, lines[j])
   for(k in word) word[k] = coerce(word[k])
   @fun(words) } }

function the 
lines(HELP,the)
