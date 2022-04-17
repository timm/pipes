# vim: ts=2 sw=2 sts=2 et :
#          __                 __              
#         /\ \__             /\ \__           
#   ____  \ \ ,_\     __     \ \ ,_\    ____  
#  /',__\  \ \ \/   /'__`\    \ \ \/   /',__\ 
# /\__, `\  \ \ \_ /\ \L\.\_   \ \ \_ /\__, `\
# \/\____/   \ \__\\ \__/.\_\   \ \__\\/\____/
#  \/___/     \/__/ \/__/\/_/    \/__/ \/___/ 
#                                             
                                            
"""
cat stats | python3 stats.py [OPTIONS]
Report stats on each column

OPTIONS:
  --help -h       show help       = False
  --copy -C       show copyright  = False
"""
import re,ako,sys
from lib import o,cli,sd,per,csv,ent,atom

the = cli(__doc__)

def add(col,x):
  if type(col)==list: col += [x]
  else:               col[x] = 1 + col.get(x,0)

def stats(col):
  if type(col)==list:
     col=sorted(col)
     return per(col,.5), sd(col)
  else:
    most, mode = 0, None
    for x,n in col.items():
      if n > most: most,mode = n,x
    return mode, ent(col)
    
def main(the):
  cols=None
  for n,row in enumerate(csv()):
    if    n==0: cols= [o(name=s,seen=([] if ako.nump(s) else {})) for s in row]
    else      : [add(col.seen,atom(x)) for col,x in zip(cols,row) if x != "?"] 
  [print(col.name, *stats(col.seen),sep=",") for col in cols]

if __name__ == "__main__": main(the)
