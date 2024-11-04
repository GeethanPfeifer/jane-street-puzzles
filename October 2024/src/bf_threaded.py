"""
Running bf in multiple threads.
This turned out to be unnecessary.
"""

import itertools
import subprocess
import time

num_subp = 8

def s3(t):
    return t[0] + t[1] + t[2]


def dtu(x,t):
    return not(t[0]==t[1] or t[0]==t[2] or t[1] == t[2] or s3(t) >= x)

""" currying style from https://python-course.eu/advanced-python/currying-in-python.php """
def dtu1(x):
    def dtu2(t):
        return dtu(x,t)
    return dtu2


def triplets_under(x):
    return sorted(list(filter(dtu1(x), list(itertools.product(list(range(1,x)), list(range(1,x)), list(range(1,x)))))), key=s3)
    
def tti(t):
    return str(t[0]) + "\n" + str(t[1]) + "\n" + str(t[2])


tu10 = triplets_under(10)
subp = []



for i in range(num_subp):
    ttt = tu10[i]
    subp.append(subprocess.Popen("./bf" + " " + str(ttt[0]) + " " + str(ttt[1]) + " " + str(ttt[2]), shell=True, stdout = subprocess.PIPE, text=True))
    
    
c = num_subp
while(c <= len(tu10) + num_subp):
    time.sleep(10)
    
    for i in range(num_subp):
        if(subp[i] != None):
            pv = subp[i].poll()
            if(pv != None):
                if(pv == 0):
                    print(subp[i].communicate()[0])
                    
                    c = 9999
                    """ do i need to kill the processes? I don't think so """
                else:
                    subp[i].kill()
                    if(c < len(tu10)):
                        ttt = tu10[c]
                        subp[i] = subprocess.Popen("./bf" + " " + str(ttt[0]) + " " + str(ttt[1]) + " " + str(ttt[2]), shell=True, stdout = subprocess.PIPE, text=True)
                    else:
                        subp[i] = None
                    c+=1










