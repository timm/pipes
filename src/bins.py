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
cat data | python3 bins.py [OPTIONS]
Report stats on each column

OPTIONS:
  --bins -b       number of bins  = 10
  --help -h       show help       = False
  --copy -C       show copyright  = False
"""
import re,sys
import ako
from lib import o,cli,sd,per,csv,ent,atom

the = cli(__doc__)

def add(col,x):
  lo = col.lo = min(x, col.lo)
  hi = col.hi = max(x, col.hi)
  x = 0 if abs(hi - lo) < 1E-9  else int((x - lo)/(hi - lo)*the.bins)
  return max(0, min(x, the.bins - 1))

def num(at): return o(at=at, lo=sys.maxsize, hi=-sys.maxsize)

def main(the):
  nums = []
  for n,row in enumerate(csv()):
    if n==0: 
      nums= [num(at) for at,s in enumerate(row) if ako.nump(s)]
    else: 
      for col in nums: 
        x = row[col.at]
        if x != "?": row[col.at] = add(col, atom(x))
    print(*row,sep=",")

if __name__ == "__main__": main(the)
