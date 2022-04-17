# vim: ts=2 sw=2 sts=2 et :
#   __                               
#  /\ \                              
#  \ \ \____    ___    _ __     __   
#   \ \ '__`\  / __`\ /\`'__\ /'__`\ 
#    \ \ \L\ \/\ \L\ \\ \ \/ /\  __/ 
#     \ \_,__/\ \____/ \ \_\ \ \____\
#      \/___/  \/___/   \/_/  \/____/
                                            
"""
cat data | py bins | py bore  [OPTIONS]
classify data into best or rest

OPTIONS:
  --best -b       size of best set= .1
  --help -h       show help       = False
  --copy -C       show copyright  = False
"""
import re,ako,sys
from lib import o,cli,csv,atom
from collections import defaultdict
count = lambda: defaultdict(count)

the = cli(__doc__)

def col(at,s): 
  return o(at=at, best=count(), rest=count(), want=0 if  ako.lessp(s) else 1)

def score(cols,row): 
  return sum((c.want - row[c.at])**2 for c in cols)**.5

def meta(egs,row):
  out = o(x=[], y=[])
  for at,name in enumerate(row):
    (out.y if ako.goalp(name) else out.x).append( col(at,name) )
  return out

def main(the):
  egs = o(x=[], y=[])
  for n,row in enumerate(csv()):
    if n==0: cols  = cols([cols(egs,(i,s) if ako.goal(s) else x(i) for i,s in enumerate(row)]
    else   : rows += [o(val=score(goals,row), row=row)]
  rows = sorted(rows, key=lambda x: x.val)
  best = int(the.best*len(rows))
  bests, rests = rows[:best], rows[best:]
  counts(bests,cols,"bests")
  counts(bests,cols,"wrests")
  

if __name__ == "__main__": main(the)
