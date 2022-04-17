# vim: ts=2 sw=2 sts=2 et :
#           __                     ___     ___   ___              
#          /\ \                  /'___\  /'___\ /\_ \             
#    ____  \ \ \___     __  __  /\ \__/ /\ \__/ \//\ \       __   
#   /',__\  \ \  _ `\  /\ \/\ \ \ \ ,__\\ \ ,__\  \ \ \    /'__`\ 
#  /\__, `\  \ \ \ \ \ \ \ \_\ \ \ \ \_/ \ \ \_/   \_\ \_ /\  __/ 
#  \/\____/   \ \_\ \_\ \ \____/  \ \_\   \ \_\    /\____\\ \____\
#   \/___/     \/_/\/_/  \/___/    \/_/    \/_/    \/____/ \/____/
                                            
"""
cat data | python3 shuffle.py [OPTIONS]
Print row1 then the remaining rows in a random order

OPTIONS:
  --seed -s   random number seed = 10019
  --help -h   show help          = False
  --copy -C    show copyright    = False
"""
import sys,random
from lib import cli,csv

the = cli(__doc__)
random.seed(the.seed)

def shuffle(the):
  rows = []
  for n,row in enumerate(csv()):
    if n==0: print(*row,sep=",")
    else   : rows += [row]
  random.shuffle(rows)
  [print(*row,sep=",") for row in rows]

if __name__ == "__main__": shuffle(the)
