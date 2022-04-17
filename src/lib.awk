BEGIN { DOT=sprintf("%c",46) }

function auk2awk(f,  klass,a) {
  while (getline <f) {
    if (/^func(tion)?[ \t]+[A-Z][^\(]*\(/){split($0,a,/[ \t\(]/);klass=a[2]}
    gsub(/[ \t]_/," " klass)
    print gensub(/\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/, "[\"\\1\\2\"]","g", $0)}}

function Obj(i)  { 
  split("",i,"")
  i["is"]= "Obj"
  i["id"] = ++ID }

function at(i,k) { i[k]["\001"]; delete i[j]["\001"]; return k}
function add(i)  { return at(i, length(i)+1) }

function oo(x,p,pre, i,txt) {
  txt = pre ? pre : (p DOT)
  PROCINFO["sorted_in"]=typeof(first(x))=="number"?"@ind_num_asc":"@ind_str_asc"
  for(i in x)  {
    if (isarray(x[i])) { print(txt i"" ); oo(x[i],"","|  " pre) }
    else               { print(txt i (x[i]==""?"":": "x[i]))  }}}

function first(x, i) { for (i in x) return x[i] }

function rogues(    s) {
  for(s in SYMTAB) if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) if (s ~ /^[_a-z]/    ) print "#W> Rogue: " s>"/dev/stderr"
}

function tests(what, all,   one,a,i,n) {
  n = split(all,a,",")
  print "\n#--- " what " -----------------------"
  for(i=1;i<=n;i++) { one = a[i]; @one(one) }
  rogues() }


